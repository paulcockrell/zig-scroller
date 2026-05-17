const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub const Query = struct {
    pub fn players(
        world: *ecs.World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: ecs.Entity,
            anim: *ecs.Animation,
            pos: *ecs.Position,
            vel: *ecs.Velocity,
            dim: *ecs.Dimension,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.players.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn enemies(
        world: *ecs.World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: ecs.Entity,
            anim: *ecs.Animation,
            pos: *ecs.Position,
            vel: *ecs.Velocity,
            dim: *ecs.Dimension,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.enemies.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn rings(
        world: *ecs.World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: ecs.Entity,
            anim: *ecs.Animation,
            pos: *ecs.Position,
            vel: *ecs.Velocity,
            dim: *ecs.Dimension,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.rings.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn backgrounds(
        world: *ecs.World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: ecs.Entity,
            anim: *ecs.Animation,
            pos: *ecs.Position,
            vel: *ecs.Velocity,
            dim: *ecs.Dimension,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.backgrounds.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn platforms(
        world: *ecs.World,
        ctx: anytype,
        func: fn (
            ctx: @TypeOf(ctx),
            ent: ecs.Entity,
            anim: *ecs.Animation,
            pos: *ecs.Position,
            vel: *ecs.Velocity,
            dim: *ecs.Dimension,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.platforms.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            const anim = world.animations.getPtr(ent) orelse continue;
            const pos = world.positions.getPtr(ent) orelse continue;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const dim = world.dimensions.getPtr(ent) orelse continue;

            func(
                ctx,
                ent,
                anim,
                pos,
                vel,
                dim,
                world,
            );
        }
    }

    pub fn needsReset(
        world: *ecs.World,
        func: fn (
            ent: ecs.Entity,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.needs_reset.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;

            func(
                ent,
                world,
            );
        }
    }

    pub fn jumpIntents(
        world: *ecs.World,
        func: fn (
            vel: *ecs.Velocity,
            intent: *ecs.JumpIntent,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.jump_intents.iterator();

        while (it.next()) |entry| {
            const ent = entry.key_ptr.*;
            const vel = world.velocities.getPtr(ent) orelse continue;
            const intent = world.jump_intents.getPtr(ent) orelse continue;

            func(
                vel,
                intent,
                world,
            );
        }
    }

    pub fn soundIntents(
        world: *ecs.World,
        func: fn (
            sound_tag: ecs.SoundTag,
            sound_params: *ecs.SoundParams,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.sound_intents.iterator();

        while (it.next()) |entry| {
            const sound_tag = entry.key_ptr.*;
            const sound_params = entry.value_ptr;

            func(
                sound_tag,
                sound_params,
                world,
            );
        }
    }

    pub fn sounds(
        world: *ecs.World,
        func: fn (
            sound_tag: ecs.SoundTag,
            sound: *raylib.Sound,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.sounds.iterator();

        while (it.next()) |entry| {
            const sound_tag = entry.key_ptr.*;
            const sound = entry.value_ptr;

            func(
                sound_tag,
                sound,
                world,
            );
        }
    }
};
