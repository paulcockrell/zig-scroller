const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const audio_tags = @import("../systems/resources/audio_tags.zig");
const texture_tags = @import("../systems/resources/texture_tags.zig");

const AudioTag = audio_tags.AudioTag;
const AudioParams = audio_tags.AudioParams;
const TextureTag = texture_tags.TextureTag;

pub const Scene = enum { main_menu, game_play, game_over, credits };

pub const World = struct {
    allocator: std.mem.Allocator,

    next_entity: ecs.Entity = 0,

    screen_width: i32 = 0,
    screen_height: i32 = 0,

    health: i32 = ecs.MAX_HEALTH,
    score: i32 = 0,

    positions: std.AutoHashMap(ecs.Entity, ecs.Position),
    velocities: std.AutoHashMap(ecs.Entity, ecs.Velocity),
    dimensions: std.AutoHashMap(ecs.Entity, ecs.Dimension),
    animations: std.AutoHashMap(ecs.Entity, ecs.Animation),

    players: std.AutoHashMap(ecs.Entity, void),
    enemies: std.AutoHashMap(ecs.Entity, void),
    rings: std.AutoHashMap(ecs.Entity, void),
    platforms: std.AutoHashMap(ecs.Entity, void),
    backgrounds: std.AutoHashMap(ecs.Entity, void),

    needs_reset: std.AutoHashMap(ecs.Entity, void),
    jump_intents: std.AutoHashMap(ecs.Entity, ecs.JumpIntent),
    sound_intents: std.AutoHashMap(AudioTag, AudioParams),
    scene_transition_intents: std.AutoHashMap(ecs.Scene, void),
    jump_intent: bool,
    confirm_intent: bool,
    popup_points: i32,
    popup_points_timer: f32,

    prng: std.Random.Xoshiro256,

    time: f32,
    scroll_speed: f32,

    scene: Scene,

    pub fn init(allocator: std.mem.Allocator, screen_width: i32, screen_height: i32) World {
        return .{
            .screen_width = screen_width,
            .screen_height = screen_height,
            .allocator = allocator,
            .positions = std.AutoHashMap(ecs.Entity, ecs.Position).init(allocator),
            .velocities = std.AutoHashMap(ecs.Entity, ecs.Velocity).init(allocator),
            .dimensions = std.AutoHashMap(ecs.Entity, ecs.Dimension).init(allocator),
            .players = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .enemies = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .rings = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .platforms = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .backgrounds = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .needs_reset = std.AutoHashMap(ecs.Entity, void).init(allocator),
            .jump_intents = std.AutoHashMap(ecs.Entity, ecs.JumpIntent).init(allocator),
            .animations = std.AutoHashMap(ecs.Entity, ecs.Animation).init(allocator),
            .sound_intents = std.AutoHashMap(AudioTag, AudioParams).init(allocator),
            .scene_transition_intents = std.AutoHashMap(ecs.Scene, void).init(allocator),
            .jump_intent = false,
            .confirm_intent = false,
            .popup_points_timer = 0.0,
            .popup_points = 0,
            .prng = std.Random.DefaultPrng.init(std.testing.random_seed),
            .time = 0.0,
            .scroll_speed = ecs.BASE_SCROLL_SPEED,
            .scene = Scene.main_menu,
        };
    }

    pub fn deinit(self: *World) void {
        self.positions.deinit();
        self.velocities.deinit();
        self.dimensions.deinit();
        self.players.deinit();
        self.enemies.deinit();
        self.rings.deinit();
        self.platforms.deinit();
        self.backgrounds.deinit();
        self.needs_reset.deinit();
        self.jump_intents.deinit();
        self.animations.deinit();
        self.sound_intents.deinit();
        self.scene_transition_intents.deinit();
    }

    pub fn reset(self: *World) void {
        self.positions.clearRetainingCapacity();
        self.velocities.clearRetainingCapacity();
        self.dimensions.clearRetainingCapacity();
        self.players.clearRetainingCapacity();
        self.enemies.clearRetainingCapacity();
        self.rings.clearRetainingCapacity();
        self.platforms.clearRetainingCapacity();
        self.backgrounds.clearRetainingCapacity();
        self.needs_reset.clearRetainingCapacity();
        self.jump_intents.clearRetainingCapacity();
        self.sound_intents.clearRetainingCapacity();
        self.score = 0;
        self.time = 0;
        self.jump_intent = false;
        self.confirm_intent = false;
        self.popup_points = 0;
        self.popup_points_timer = 0.0;
        self.health = ecs.MAX_HEALTH;
        self.scroll_speed = ecs.BASE_SCROLL_SPEED;
    }

    pub fn createEntity(self: *World) ecs.Entity {
        const id = self.next_entity;
        self.next_entity += 1;

        return id;
    }

    pub fn updateHealth(self: *World, val: i32) i32 {
        self.health -= val;
        return self.health;
    }

    pub fn addScore(self: *World, val: i32) void {
        self.score += val;
        self.popup_points = val;
        self.popup_points_timer = ecs.POPUP_POINTS_TIMER_MAX;
    }

    pub fn rng(self: *World, floor: u16, ceil: u16) u16 {
        const rand = self.prng.random();
        const offset = rand.intRangeAtMost(u16, floor, ceil);

        return offset;
    }

    pub fn groundY(self: *World) f32 {
        return @as(f32, @floatFromInt(self.screen_height)) - ecs.PLATFORM_HEIGHT;
    }

    pub fn changeScene(self: *World, scene: ecs.Scene) !void {
        self.scene_transition_intents.put(scene, {}) catch |err| {
            std.debug.print("Add scene transition intent failed {}: {}\n", .{ scene, err });
        };
    }
};
