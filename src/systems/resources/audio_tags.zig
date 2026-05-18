pub const AudioTag = enum {
    background,
    jump,
    ring,
    hit,
    stomp,
};

pub const AudioParams = struct {
    volume: f32,
};
