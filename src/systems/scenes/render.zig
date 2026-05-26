const ecs = @import("../../engine/ecs/ecs.zig");
const main_menu = @import("../../game/scenes/main_menu.zig");
const game_play = @import("../../game/scenes/game_play.zig");
const game_over = @import("../../game/scenes/game_over.zig");
const credits = @import("../../game/scenes/credits.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    switch (world.game.scene) {
        ecs.Scene.game_play => {
            game_play.render(world, delta);
        },
        ecs.Scene.game_over => {
            game_over.render(world, delta);
        },
        ecs.Scene.credits => {
            credits.render(world, delta);
        },
        else => {
            main_menu.render(world, delta);
        },
    }
}
