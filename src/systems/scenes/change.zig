const std = @import("std");
const ecs = @import("../../ecs.zig");
const main_menu = @import("../../scenes/main_menu.zig");
const game_play = @import("../../scenes/game_play.zig");
const game_over = @import("../../scenes/game_over.zig");
const credits = @import("../../scenes/credits.zig");

pub fn system(world: *ecs.World) void {
    var it = world.game.scene_transition_intents.iterator();
    while (it.next()) |ent| {
        exitCurrentScene(world.game.scene, world);

        const new_scene = ent.key_ptr.*;
        world.game.scene = new_scene;

        enterScene(new_scene, world) catch |err| {
            std.debug.print("Failed to enter scene {}: {}", .{ new_scene, err });
        };
    }

    world.scene_transition_intents.clearRetainingCapacity();
}

fn exitCurrentScene(scene: ecs.Scene, world: *ecs.World) void {
    switch (scene) {
        ecs.Scene.game_play => {
            game_play.exit(world);
        },
        ecs.Scene.game_over => {
            game_over.exit(world);
        },
        ecs.Scene.credits => {
            credits.exit(world);
        },
        ecs.Scene.main_menu => {
            main_menu.exit(world);
        },
    }
}

fn enterScene(scene: ecs.Scene, world: *ecs.World) !void {
    switch (scene) {
        ecs.Scene.game_play => {
            try game_play.enter(world);
        },
        ecs.Scene.game_over => {
            game_over.enter(world);
        },
        ecs.Scene.credits => {
            credits.enter(world);
        },
        ecs.Scene.main_menu => {
            try main_menu.enter(world);
        },
    }
}
