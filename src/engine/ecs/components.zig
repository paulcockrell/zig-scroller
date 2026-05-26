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

pub const JumpIntent = struct {
    force: f32,
};

pub const NeedsReset = struct {};
