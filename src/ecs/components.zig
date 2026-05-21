pub const BASE_SCROLL_SPEED: f32 = 50.0;
pub const SCROLL_SPEED_FACTOR: f32 = 5.0;
pub const MAX_SCROLL_SPEED: f32 = 250.0;
pub const MAX_HEALTH: i32 = 10;
pub const FPS: i32 = 60;
pub const PLATFORM_HEIGHT: f32 = 57.0;
pub const POPUP_POINTS_TIMER_MAX: f32 = 1.0;
pub const GRAVITY: f32 = 500.0;
pub const MAX_FALL_SPEED: f32 = 400.0;

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
