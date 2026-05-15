pub const World = @import("ecs/world.zig").World;
pub const Scene = @import("ecs/world.zig").Scene;
pub const Query = @import("ecs/query.zig").Query;
pub const Entity = @import("ecs/components.zig").Entity;
pub const SoundTag = @import("ecs/components.zig").SoundTag;
pub const SoundParams = @import("ecs/components.zig").SoundParams;
pub const SpriteTag = @import("ecs/components.zig").SpriteTag;
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

pub const changeScene = @import("ecs/world.zig").changeScene;
