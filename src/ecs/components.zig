pub const BASE_SCROLL_SPEED: f32 = 0.0;
pub const SCROLL_SPEED_FACTOR: f32 = 5.0;
pub const MAX_SCROLL_SPEED: f32 = 300.0;
pub const MAX_HEALTH: i32 = 10;
pub const FPS: i32 = 60;

pub const Entity = u32;

pub const SoundTag = enum { background, jump, ring, hit, stomp };

pub const SoundParams = struct {
    volume: f32,
};

pub const SpriteTag = enum { player, enemy, ring, background, platform };

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
