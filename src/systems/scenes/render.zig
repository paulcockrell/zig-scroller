const ecs = @import("../../ecs.zig");
const main_menu = @import("../../scenes/main_menu.zig");
const game_play = @import("../../scenes/game_play.zig");
const game_over = @import("../../scenes/game_over.zig");
const credits = @import("../../scenes/credits.zig");
const Resources = @import("../../resources/resources.zig").Resources;

pub fn system(world: *ecs.World, resources: *Resources, delta: f32) void {
    switch (world.scene) {
        ecs.Scene.game_play => {
            game_play.render(world, resources, delta);
        },
        ecs.Scene.game_over => {
            game_over.render(world, resources, delta);
        },
        ecs.Scene.credits => {
            credits.render(world, resources, delta);
        },
        else => {
            main_menu.render(world, resources, delta);
        },
    }
}
