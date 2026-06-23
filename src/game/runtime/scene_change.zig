const std = @import("std");
const World = @import("../game.zig").World;
const Scene = @import("../game.zig").Scene;
const main_menu = @import("../../game/scenes/main_menu.zig");
const game_play = @import("../../game/scenes/game_play.zig");
const game_over = @import("../../game/scenes/game_over.zig");
const credits = @import("../../game/scenes/credits.zig");

pub fn system(world: *World) void {
    if (world.game.next_scene) |next_scene| {
        exitCurrentScene(world.game.scene, world);

        world.game.changeScene();

        enterScene(world, next_scene) catch |err| {
            std.debug.print("Failed to enter scene {}: {}", .{ next_scene, err });
        };
    }
}

fn exitCurrentScene(scene: Scene, world: *World) void {
    switch (scene) {
        Scene.game_play => {
            game_play.exit(world);
        },
        Scene.game_over => {
            game_over.exit(world);
        },
        Scene.credits => {
            credits.exit(world);
        },
        Scene.main_menu => {
            main_menu.exit(world);
        },
    }
}

fn enterScene(world: *World, next_scene: Scene) !void {
    switch (next_scene) {
        Scene.game_play => {
            try game_play.enter(world);
        },
        Scene.game_over => {
            game_over.enter(world);
        },
        Scene.credits => {
            credits.enter(world);
        },
        Scene.main_menu => {
            try main_menu.enter(world);
        },
    }
}
