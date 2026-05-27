const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../engine/ecs/ecs.zig");
const Resources = @import("../engine/assets/resources.zig").Resources;
const AudioTag = @import("../engine/assets/audio_tags.zig").AudioTag;
const AudioParams = @import("../engine/assets/audio_tags.zig").AudioParams;
const MAX_HEALTH = @import("game.zig").MAX_HEALTH;
const BASE_SCROLL_SPEED = @import("game.zig").BASE_SCROLL_SPEED;
const PLATFORM_HEIGHT = @import("entities/platform.zig").PLATFORM_HEIGHT;

const POPUP_POINTS_TIMER_MAX: f32 = 1.0;

pub const Scene = enum { main_menu, game_play, game_over, credits };

pub const World = struct {
    ecs: ECS,
    game: GameState,
    resources: Resources,

    pub fn init(allocator: std.mem.Allocator, screen_width: i32, screen_height: i32) !World {
        return .{
            .ecs = ECS.init(
                allocator,
            ),
            .game = GameState.init(
                allocator,
                screen_width,
                screen_height,
            ),
            .resources = try Resources.init(
                allocator,
            ),
        };
    }

    pub fn deinit(self: *World) void {
        self.ecs.deinit();
        self.game.deinit();
        self.resources.deinit();
    }

    pub fn reset(self: *World) void {
        self.ecs.reset();
        self.game.reset();
    }
};

const ECS = struct {
    positions: std.AutoHashMap(ecs.Entity, ecs.Position),
    velocities: std.AutoHashMap(ecs.Entity, ecs.Velocity),
    dimensions: std.AutoHashMap(ecs.Entity, ecs.Dimension),
    platforms: std.AutoHashMap(ecs.Entity, void),
    backgrounds: std.AutoHashMap(ecs.Entity, void),
    animations: std.AutoHashMap(ecs.Entity, ecs.Animation),

    players: std.AutoHashMap(ecs.Entity, void),
    enemies: std.AutoHashMap(ecs.Entity, void),
    rings: std.AutoHashMap(ecs.Entity, void),

    next_entity: ecs.Entity = 0,

    pub fn init(allocator: std.mem.Allocator) ECS {
        return .{
            .positions = std.AutoHashMap(ecs.Entity, ecs.Position).init(allocator),
            .velocities = std.AutoHashMap(ecs.Entity, ecs.Velocity).init(allocator),
            .dimensions = std.AutoHashMap(ecs.Entity, ecs.Dimension).init(allocator),
            .animations = std.AutoHashMap(ecs.Entity, ecs.Animation).init(allocator),
            .players = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .enemies = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .rings = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .platforms = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .backgrounds = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .next_entity = 0,
        };
    }

    pub fn deinit(self: *ECS) void {
        self.positions.deinit();
        self.velocities.deinit();
        self.dimensions.deinit();
        self.players.deinit();
        self.enemies.deinit();
        self.rings.deinit();
        self.platforms.deinit();
        self.backgrounds.deinit();
        self.animations.deinit();
    }

    pub fn reset(self: *ECS) void {
        self.positions.clearRetainingCapacity();
        self.velocities.clearRetainingCapacity();
        self.dimensions.clearRetainingCapacity();
        self.players.clearRetainingCapacity();
        self.enemies.clearRetainingCapacity();
        self.rings.clearRetainingCapacity();
        self.platforms.clearRetainingCapacity();
        self.backgrounds.clearRetainingCapacity();
        self.animations.clearRetainingCapacity();
        self.next_entity = 0;
    }

    pub fn createEntity(self: *ECS) ecs.Entity {
        const id = self.next_entity;
        self.next_entity += 1;

        return id;
    }
};

const GameState = struct {
    time: f32 = 0.0,

    health: i32 = MAX_HEALTH,

    screen_width: i32 = 0,
    screen_height: i32 = 0,

    score: i32 = 0,
    popup_points: i32 = 0,
    popup_points_timer: f32 = 0.0,

    scroll_speed: f32 = 0.0,
    scene: Scene = Scene.main_menu,

    needs_reset: std.AutoHashMap(ecs.Entity, void),
    jump_intents: std.AutoHashMap(ecs.Entity, ecs.JumpIntent),
    sound_intents: std.AutoHashMap(AudioTag, AudioParams),
    scene_transition_intents: std.AutoHashMap(Scene, void),
    jump_intent: bool,
    confirm_intent: bool,

    prng: std.Random.Xoshiro256,

    pub fn init(allocator: std.mem.Allocator, screen_width: i32, screen_height: i32) GameState {
        return .{
            .needs_reset = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .jump_intents = std.AutoHashMap(ecs.Entity, ecs.JumpIntent).init(allocator),
            .sound_intents = std.AutoHashMap(AudioTag, AudioParams).init(allocator),
            .scene_transition_intents = std.AutoHashMap(Scene, void).init(allocator),
            .jump_intent = false,
            .confirm_intent = false,
            .time = 0.0,
            .popup_points_timer = 0.0,
            .popup_points = 0,
            .scroll_speed = BASE_SCROLL_SPEED,
            .scene = Scene.main_menu,
            .prng = std.Random.DefaultPrng.init(std.testing.random_seed),
            .screen_width = screen_width,
            .screen_height = screen_height,
        };
    }

    pub fn deinit(self: *GameState) void {
        self.needs_reset.deinit();
        self.jump_intents.deinit();
        self.sound_intents.deinit();
        self.scene_transition_intents.deinit();
    }

    pub fn reset(self: *GameState) void {
        self.needs_reset.clearRetainingCapacity();
        self.jump_intents.clearRetainingCapacity();
        self.sound_intents.clearRetainingCapacity();
        self.scene_transition_intents.clearRetainingCapacity();
        self.time = 0;
        self.health = MAX_HEALTH;
        self.score = 0;
        self.popup_points = 0;
        self.popup_points_timer = 0.0;
        self.scroll_speed = BASE_SCROLL_SPEED;
        self.scene = Scene.main_menu;
    }

    pub fn addScore(self: *GameState, val: i32) void {
        self.score += val;
        self.popup_points = val;
        self.popup_points_timer = POPUP_POINTS_TIMER_MAX;
    }

    pub fn updateHealth(self: *GameState, val: i32) i32 {
        self.health -= val;
        return self.health;
    }

    pub fn changeScene(self: *GameState, scene: Scene) !void {
        self.scene_transition_intents.put(scene, {}) catch |err| {
            std.debug.print("Add scene transition intent failed {}: {}\n", .{ scene, err });
        };
    }

    pub fn rng(self: *GameState, floor: u16, ceil: u16) u16 {
        const rand = self.prng.random();
        const offset = rand.intRangeAtMost(u16, floor, ceil);

        return offset;
    }

    pub fn groundY(self: *GameState) f32 {
        return @as(f32, @floatFromInt(self.screen_height)) - PLATFORM_HEIGHT;
    }
};
