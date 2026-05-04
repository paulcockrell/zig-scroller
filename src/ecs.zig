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

pub const Player = struct {};
pub const Obstacle = struct {};

pub const World = struct {
    screen_width: i32 = 0,
    screen_height: i32 = 0,

    scroll_speed: i32 = 100,

    allocator: std.mem.Allocator,
    next_entity: Entity = 0,

    positions: std.AutoHashMap(Entity, Position),
    velocities: std.AutoHashMap(Entity, Velocity),

    players: std.AutoHashMap(Entity, void),
    obstacles: std.AutoHashMap(Entity, void),

    pub fn init(allocator: std.mem.Allocator, screen_width: i32, screen_height: i32) World {
        return .{
            .screen_width = screen_width,
            .screen_height = screen_height,
            .allocator = allocator,
            .positions = std.AutoHashMap(Entity, Position).init(allocator),
            .velocities = std.AutoHashMap(Entity, Velocity).init(allocator),
            .players = std.AutoHashMap(Entity, void).init(allocator),
            .obstacles = std.AutoHashMap(Entity, void).init(allocator),
        };
    }

    pub fn deinit(self: *World) void {
        self.positions.deinit();
        self.velocities.deinit();
        self.players.deinit();
        self.obstacles.deinit();
    }

    pub fn createEntity(self: *World) Entity {
        const id = self.next_entity;
        self.next_entity += 1;

        return id;
    }
};

pub fn spawnPlayer(world: *World) !Entity {
    const ent = world.createEntity();

    try world.positions.put(
        ent,
        .{ .x = 100.0, .y = @as(f32, @floatFromInt(world.screen_height)) / 2.0 },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 0.0, .dy = 0.0 },
    );
    try world.players.put(
        ent,
        {},
    );

    return ent;
}

pub fn spawnObstacle(world: *World) !Entity {
    const ent = world.createEntity();

    try world.positions.put(
        ent,
        .{ .x = @as(f32, @floatFromInt(world.screen_width)), .y = @as(f32, @floatFromInt(world.screen_height)) / 2.0 },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 150.0, .dy = 0.0 },
    );
    try world.obstacles.put(
        ent,
        {},
    );

    return ent;
}

pub const Query = struct {
    pub fn players(
        world: *World,
        ctx: anytype,
        func: fn (ctx: @TypeOf(ctx), ent: Entity, pos: *Position, vel: *Velocity, world: *World) void,
    ) void {
        var it = world.players.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                pos,
                vel,
                world,
            );
        }
    }

    pub fn obstacles(
        world: *World,
        ctx: anytype,
        func: fn (ctx: @TypeOf(ctx), ent: Entity, pos: *Position, vel: *Velocity, world: *World) void,
    ) void {
        var it = world.obstacles.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                pos,
                vel,
                world,
            );
        }
    }
};
