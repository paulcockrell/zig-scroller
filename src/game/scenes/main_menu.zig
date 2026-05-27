const std = @import("std");
const raylib = @import("raylib");
const World = @import("../world.zig").World;
const Scene = @import("../world.zig").Scene;
const main_menu = @import("../rendering/main_menu.zig");
const jump = @import("../systems/jump.zig");
const scroll = @import("../systems/scroll.zig");
const game_play = @import("../rendering/game_play.zig");
const scenery_wrap = @import("../systems/scenery_wrap.zig");
const player = @import("../entities/player.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");
const Resources = @import("../../engine/assets/resources.zig").Resources;

pub fn enter(world: *World) !void {
    try player.spawn(world);
    try platform.spawn(world);
    try background.spawn(world);
}

pub fn exit(world: *World) void {
    world.reset();
}

pub fn update(world: *World, delta: f32) void {
    if (world.game.jump_intent) {
        world.game.changeScene(Scene.game_play) catch |err| {
            std.debug.print("Failed to change scene: Main Menu -> Game Play: {}\n", .{err});
        };
    }

    if (world.game.confirm_intent) {
        world.game.changeScene(Scene.credits) catch |err| {
            std.debug.print("Failed to change scene: Main Menu -> Credits: {}\n", .{err});
        };
    }

    jump.system(world, delta);
    scroll.system(world, delta);
    scenery_wrap.system(world);
}

pub fn render(world: *World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    game_play.system(world, delta);
    main_menu.system(world);
}
