const std = @import("std");

pub const Entity = u32;

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

    scroll_speed: i32 = 100,

    score: i32 = 0,

    positions: std.AutoHashMap(Entity, Position),
    velocities: std.AutoHashMap(Entity, Velocity),
    dimensions: std.AutoHashMap(Entity, Dimension),

    players: std.AutoHashMap(Entity, void),
    enemies: std.AutoHashMap(Entity, void),
    rings: std.AutoHashMap(Entity, void),

    needs_reset: std.AutoHashMap(Entity, void),
    jump_intents: std.AutoHashMap(Entity, JumpIntent),

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
            .needs_reset = std.AutoHashMap(Entity, void).init(allocator),
            .jump_intents = std.AutoHashMap(Entity, JumpIntent).init(allocator),
        };
    }

    pub fn deinit(self: *World) void {
        self.positions.deinit();
        self.velocities.deinit();
        self.dimensions.deinit();
        self.players.deinit();
        self.enemies.deinit();
        self.rings.deinit();
        self.needs_reset.deinit();
        self.jump_intents.deinit();
    }

    pub fn createEntity(self: *World) Entity {
        const id = self.next_entity;
        self.next_entity += 1;

        return id;
    }

    pub fn updateScore(self: *World, val: i32) i32 {
        self.score += val;
        return self.score;
    }
};

pub const Query = struct {
    pub fn players(
        world: *World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: Entity,
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.players.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
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
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.enemies.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
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
            pos: *Position,
            vel: *Velocity,
            dim: *Dimension,
            world: *World,
        ) void,
    ) void {
        var it = world.rings.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
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
