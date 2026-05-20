const ecs = @import("../../ecs.zig");
const main_menu = @import("../../scenes/main_menu.zig");
const game_play = @import("../../scenes/game_play.zig");
const game_over = @import("../../scenes/game_over.zig");
const credits = @import("../../scenes/credits.zig");
const Resources = @import("../../resources/resources.zig").Resources;

pub fn system(world: *ecs.World, resources: *Resources, delta: f32) void {
    switch (world.scene) {
        ecs.Scene.game_play => {
            game_play.update(world, resources, delta);
        },
        ecs.Scene.game_over => {
            game_over.update(world, delta);
        },
        ecs.Scene.credits => {
            credits.update(world, delta);
        },
        else => {
            main_menu.update(world, delta);
        },
    }
}
