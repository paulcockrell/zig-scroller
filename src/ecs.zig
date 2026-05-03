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
    allocator: std.mem.Allocator,
    next_entity: Entity = 0,

    positions: std.AutoHashMap(Entity, Position),
    velocities: std.AutoHashMap(Entity, Velocity),

    players: std.AutoHashMap(Entity, void),
    obstacles: std.AutoHashMap(Entity, void),

    pub fn init(allocator: std.mem.Allocator) World {
        return .{
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
    const e = world.createEntity();

    try world.positions.put(e, .{ .x = 100, .y = 200 });
    try world.velocities.put(e, .{ .dx = 0, .dy = 0 });
    try world.players.put(e, {});

    return e;
}

pub fn movementSystem(world: *World, dt: f32) void {
    var it = world.positions.iterator();

    while (it.next()) |entry| {
        const e = entry.key_ptr.*;
        const pos = entry.value_ptr;

        if (world.velocities.get(e)) |vel| {
            pos.x += vel.dx * dt;
            pos.y += vel.dy * dt;
        }
    }
}
