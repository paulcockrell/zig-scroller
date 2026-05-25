const std = @import("std");
const App = @import("app/app.zig").App;

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var app = try App.init(allocator);
    defer app.deinit();

    try app.run();
}
