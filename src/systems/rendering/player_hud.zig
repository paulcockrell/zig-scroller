const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const resource_system = @import("../resources/resources.zig");

const Resources = resource_system.Resources;

const OFFSET_Y: f32 = 25.0;
const FONT_SIZE: i32 = 16;

pub fn system(world: *ecs.World, resources: *Resources, delta: f32) void {
    var it = world.players.iterator();
    while (it.next()) |entry| {
        const pos = world.positions.getPtr(entry) orelse continue;
        const dim = world.dimensions.getPtr(entry) orelse continue;

        displayPlayerHud(
            world,
            resources,
            pos,
            dim,
            delta,
        );
    }
}

fn displayPlayerHud(
    world: *ecs.World,
    resources: *Resources,
    pos: *ecs.Position,
    dim: *ecs.Dimension,
    delta: f32,
) void {
    if (world.player_hud_timer <= 0.0) {
        world.player_hud_timer = 0;
        world.player_hud_score = 0;
        return;
    } else {
        world.player_hud_timer -= delta;
    }

    const text = raylib.textFormat("+%d", .{world.player_hud_score});
    const text_width = raylib.measureText(text, FONT_SIZE);
    const x = pos.x + (dim.width / 2.0) - (@as(f32, @floatFromInt(text_width)) / 2.0);
    const y = pos.y - OFFSET_Y;

    resources.text.drawTextPixel(
        text,
        x,
        y,
        FONT_SIZE,
        raylib.Color.white,
    );
}
