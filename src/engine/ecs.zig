const std = @import("std");

pub const Entity = u32;

pub const Animation = struct {
    animation_timer: f32,
    frame_duration: f32,
    frame_idx: i32,
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

pub const EntityBundle = struct {
    ent: Entity,
    pos: *Position,
    dim: *Dimension,
    vel: ?*Velocity = null,
};

pub const JumpIntent = struct {
    force: f32,
};

pub const NeedsReset = struct {};

pub const Health = i32;

pub const ECS = struct {
    positions: std.AutoHashMap(Entity, Position),
    velocities: std.AutoHashMap(Entity, Velocity),
    dimensions: std.AutoHashMap(Entity, Dimension),
    platforms: std.AutoHashMap(Entity, void),
    backgrounds: std.AutoHashMap(Entity, void),
    animations: std.AutoHashMap(Entity, Animation),
    health: std.AutoHashMap(Entity, Health),

    players: std.AutoHashMap(Entity, void),
    enemies: std.AutoHashMap(Entity, void),
    rings: std.AutoHashMap(Entity, void),

    next_entity: Entity = 0,

    pub fn init(allocator: std.mem.Allocator) ECS {
        return .{
            .positions = std.AutoHashMap(Entity, Position).init(allocator),
            .velocities = std.AutoHashMap(Entity, Velocity).init(allocator),
            .dimensions = std.AutoHashMap(Entity, Dimension).init(allocator),
            .animations = std.AutoHashMap(Entity, Animation).init(allocator),
            .players = std.AutoHashMap(Entity, void).init(allocator),
            .enemies = std.AutoHashMap(Entity, void).init(allocator),
            .rings = std.AutoHashMap(Entity, void).init(allocator),
            .platforms = std.AutoHashMap(Entity, void).init(allocator),
            .backgrounds = std.AutoHashMap(Entity, void).init(allocator),
            .health = std.AutoHashMap(Entity, Health).init(allocator),
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
        self.health.deinit();
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
        self.health.clearRetainingCapacity();
        self.next_entity = 0;
    }

    pub fn createEntity(self: *ECS) Entity {
        const id = self.next_entity;
        self.next_entity += 1;

        return id;
    }
};
