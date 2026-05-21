pub const World = @import("ecs/world.zig").World;
pub const Scene = @import("ecs/world.zig").Scene;
pub const Entity = @import("ecs/components.zig").Entity;
pub const Animation = @import("ecs/components.zig").Animation;
pub const Position = @import("ecs/components.zig").Position;
pub const Velocity = @import("ecs/components.zig").Velocity;
pub const Dimension = @import("ecs/components.zig").Dimension;
pub const JumpIntent = @import("ecs/components.zig").JumpIntent;
pub const NeedsReset = @import("ecs/components.zig").NeedsReset;

pub const BASE_SCROLL_SPEED = @import("ecs/components.zig").BASE_SCROLL_SPEED;
pub const SCROLL_SPEED_FACTOR = @import("ecs/components.zig").SCROLL_SPEED_FACTOR;
pub const MAX_SCROLL_SPEED = @import("ecs/components.zig").MAX_SCROLL_SPEED;
pub const MAX_HEALTH = @import("ecs/components.zig").MAX_HEALTH;
pub const FPS = @import("ecs/components.zig").FPS;
pub const PLATFORM_HEIGHT = @import("ecs/components.zig").PLATFORM_HEIGHT;
pub const POPUP_POINTS_TIMER_MAX = @import("ecs/components.zig").POPUP_POINTS_TIMER_MAX;
pub const GRAVITY = @import("ecs/components.zig").GRAVITY;
pub const MAX_FALL_SPEED = @import("ecs/components.zig").MAX_FALL_SPEED;
pub const VIRTUAL_SCREEN_WIDTH = @import("ecs/components.zig").VIRTUAL_SCREEN_WIDTH;
pub const VIRTUAL_SCREEN_HEIGHT = @import("ecs/components.zig").VIRTUAL_SCREEN_HEIGHT;
pub const SCREEN_WIDTH = @import("ecs/components.zig").SCREEN_WIDTH;
pub const SCREEN_HEIGHT = @import("ecs/components.zig").SCREEN_HEIGHT;

pub const AUDIO_DIR = "resources/audio/";
pub const GRAPHICS_DIR = "resources/graphics/";
pub const FONTS_DIR = "resources/fonts/";
