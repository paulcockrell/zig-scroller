const std = @import("std");
const World = @import("../game.zig").World;
const Scene = @import("../game.zig").Scene;
const main_menu = @import("../../game/scenes/main_menu.zig");
const game_play = @import("../../game/scenes/game_play.zig");
const game_over = @import("../../game/scenes/game_over.zig");
const credits = @import("../../game/scenes/credits.zig");

pub fn system(world: *World) void {
    var it = world.game.scene_transition_intents.iterator();
    while (it.next()) |ent| {
        exitCurrentScene(world.game.scene, world);

        const new_scene = ent.key_ptr.*;
        world.game.scene = new_scene;

        enterScene(new_scene, world) catch |err| {
            std.debug.print("Failed to enter scene {}: {}", .{ new_scene, err });
        };
    }

    world.game.scene_transition_intents.clearRetainingCapacity();
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

fn enterScene(scene: Scene, world: *World) !void {
    switch (scene) {
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
