const World = @import("../world.zig").World;
const Scene = @import("../world.zig").Scene;
const main_menu = @import("../../game/scenes/main_menu.zig");
const game_play = @import("../../game/scenes/game_play.zig");
const game_over = @import("../../game/scenes/game_over.zig");
const credits = @import("../../game/scenes/credits.zig");

pub fn system(world: *World, delta: f32) void {
    switch (world.game.scene) {
        Scene.game_play => {
            game_play.render(world, delta);
        },
        Scene.game_over => {
            game_over.render(world, delta);
        },
        Scene.credits => {
            credits.render(world, delta);
        },
        else => {
            main_menu.render(world, delta);
        },
    }
}
