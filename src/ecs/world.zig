const std = @import("std");
const raylib = @import("raylib");
const resource_audio = @import("../systems/resources/audio.zig");
const resource_textures = @import("../systems/resources/textures.zig");
const ecs = @import("../ecs.zig");

pub const Scene = enum { main_menu, game_play, game_over, credits };

pub const World = struct {
    allocator: std.mem.Allocator,

    next_entity: ecs.Entity = 0,

    screen_width: i32 = 0,
    screen_height: i32 = 0,

    health: i32 = 10,
    score: i32 = 0,

    positions: std.AutoHashMap(ecs.Entity, ecs.Position),
    velocities: std.AutoHashMap(ecs.Entity, ecs.Velocity),
    dimensions: std.AutoHashMap(ecs.Entity, ecs.Dimension),
    sprites: std.AutoHashMap(ecs.SpriteTag, raylib.Texture2D),
    animations: std.AutoHashMap(ecs.Entity, ecs.Animation),
    sounds: std.AutoHashMap(ecs.SoundTag, raylib.Sound),

    players: std.AutoHashMap(ecs.Entity, void),
    enemies: std.AutoHashMap(ecs.Entity, void),
    rings: std.AutoHashMap(ecs.Entity, void),
    platforms: std.AutoHashMap(ecs.Entity, void),
    backgrounds: std.AutoHashMap(ecs.Entity, void),

    needs_reset: std.AutoHashMap(ecs.Entity, void),
    jump_intents: std.AutoHashMap(ecs.Entity, ecs.JumpIntent),
    sound_intents: std.AutoHashMap(ecs.SoundTag, ecs.SoundParams),
    scene_transition_intents: std.AutoHashMap(ecs.Scene, void),
    confirm_intent: bool,
    quit_intent: bool,

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
            .sprites = std.AutoHashMap(ecs.SpriteTag, raylib.Texture2D).init(allocator),
            .animations = std.AutoHashMap(ecs.Entity, ecs.Animation).init(allocator),
            .sounds = std.AutoHashMap(ecs.SoundTag, raylib.Sound).init(allocator),
            .sound_intents = std.AutoHashMap(ecs.SoundTag, ecs.SoundParams).init(allocator),
            .scene_transition_intents = std.AutoHashMap(ecs.Scene, void).init(allocator),
            .confirm_intent = false,
            .quit_intent = false,
            .prng = std.Random.DefaultPrng.init(std.testing.random_seed),
            .time = 0.0,
            .scroll_speed = ecs.BASE_SCROLL_SPEED,
            .scene = Scene.main_menu,
        };
    }

    pub fn deinit(self: *World) void {
        resource_audio.deinit(self);

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
        self.sprites.deinit();
        self.animations.deinit();
        self.sounds.deinit();
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

    pub fn updateScore(self: *World, val: i32) i32 {
        self.score += val;
        return self.score;
    }

    pub fn rng(self: *World, floor: u16, ceil: u16) u16 {
        const rand = self.prng.random();
        const offset = rand.intRangeAtMost(u16, floor, ceil);

        return offset;
    }

    pub fn groundY(self: *World) f32 {
        return @as(f32, @floatFromInt(self.screen_height)) / 2.0;
    }

    pub fn changeScene(self: *World, scene: ecs.Scene) !void {
        self.scene_transition_intents.put(scene, {}) catch |err| {
            std.debug.print("Add scene transition intent failed {}: {}\n", .{ scene, err });
        };
    }
};
