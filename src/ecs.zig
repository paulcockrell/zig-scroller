const std = @import("std");
const raylib = @import("raylib");

pub const BASE_SCROLL_SPEED: f32 = 50.0;
pub const SCROLL_SPEED_FACTOR: f32 = 5.0;
pub const MAX_SCROLL_SPEED: f32 = 400.0;
pub const FPS: i32 = 60;

pub const Entity = u32;

pub const SpriteTag = enum { player, enemy, ring, background, platform };

pub const Animation = struct {
    animation_timer: f32,
    frame_duration: f32,
    current_frame: i32,
    frame_count: i32,
};

pub const Position = struct {
    x: f32,
    y: f32,
};

pub const Velocity = struct {
    dx: f32,
    dy: f32,
};

pub const Dimension = struct {
    width: f32,
    height: f32,
};

pub const JumpIntent = struct {
    force: f32,
};

pub const NeedsReset = struct {};

pub const World = struct {
    allocator: std.mem.Allocator,

    next_entity: Entity = 0,

    screen_width: i32 = 0,
    screen_height: i32 = 0,

    health: i32 = 10,
    score: i32 = 0,

    positions: std.AutoHashMap(Entity, Position),
    velocities: std.AutoHashMap(Entity, Velocity),
    dimensions: std.AutoHashMap(Entity, Dimension),
    sprites: std.AutoHashMap(SpriteTag, raylib.Texture2D),
    animations: std.AutoHashMap(Entity, Animation),

    players: std.AutoHashMap(Entity, void),
    enemies: std.AutoHashMap(Entity, void),
    rings: std.AutoHashMap(Entity, void),
    platforms: std.AutoHashMap(Entity, void),
    backgrounds: std.AutoHashMap(Entity, void),

    needs_reset: std.AutoHashMap(Entity, void),
    jump_intents: std.AutoHashMap(Entity, JumpIntent),

    prng: std.Random.Xoshiro256,

    time: f32,
    scroll_speed: f32,

    pub fn init(allocator: std.mem.Allocator, screen_width: i32, screen_height: i32) World {
        return .{
            .screen_width = screen_width,
            .screen_height = screen_height,
            .allocator = allocator,
            .positions = std.AutoHashMap(Entity, Position).init(allocator),
            .velocities = std.AutoHashMap(Entity, Velocity).init(allocator),
            .dimensions = std.AutoHashMap(Entity, Dimension).init(allocator),
            .players = std.AutoHashMap(Entity, void).init(allocator),
            .enemies = std.AutoHashMap(Entity, void).init(allocator),
            .rings = std.AutoHashMap(Entity, void).init(allocator),
            .platforms = std.AutoHashMap(Entity, void).init(allocator),
            .backgrounds = std.AutoHashMap(Entity, void).init(allocator),
            .needs_reset = std.AutoHashMap(Entity, void).init(allocator),
            .jump_intents = std.AutoHashMap(Entity, JumpIntent).init(allocator),
            .sprites = std.AutoHashMap(SpriteTag, raylib.Texture2D).init(allocator),
            .animations = std.AutoHashMap(Entity, Animation).init(allocator),
            .prng = std.Random.DefaultPrng.init(std.testing.random_seed),
            .time = 0.0,
            .scroll_speed = BASE_SCROLL_SPEED,
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
        self.sprites.deinit();
        self.animations.deinit();
    }

    pub fn createEntity(self: *World) Entity {
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

    pub fn rng(world: *World, floor: u16, ceil: u16) u16 {
        const rand = world.prng.random();
        const offset = rand.intRangeAtMost(u16, floor, ceil);

        return offset;
    }
};

pub const Query = struct {
    pub fn players(
        world: *World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: Entity,
            anim: *Animation,
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.players.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn enemies(
        world: *World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: Entity,
            anim: *Animation,
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.enemies.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn rings(
        world: *World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: Entity,
            anim: *Animation,
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.rings.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn backgrounds(
        world: *World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: Entity,
            anim: *Animation,
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.backgrounds.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn platforms(
        world: *World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: Entity,
            anim: *Animation,
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.platforms.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn needs_reset(
        world: *World,
        func: fn (
            ent: Entity,
            world: *World,
        ) void,
    ) void {
        var it = world.needs_reset.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            func(
                ent,
                world,
            );
        }
    }

    pub fn jump_intent(
        world: *World,
        func: fn (
            vel: *Velocity,
            intent: *JumpIntent,
        ) void,
    ) void {
        var it = world.jump_intents.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const intent = world.jump_intents.getPtr(ent) orelse continue;

            func(
                vel,
                intent,
            );
        }
    }
};

pub fn groundY(world: *World) f32 {
    return @as(f32, @floatFromInt(world.screen_height)) / 2.0;
}
