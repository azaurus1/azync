const std = @import("std");
const okredis = @import("okredis");
const azync = @import("azync");
const Client = okredis.Client;

pub fn main() !void {
    const addr = try std.net.Address.parseIp4("127.0.0.1", 6379);
    const connection = try std.net.tcpConnectToAddress(addr);

    var rbuf: [1024]u8 = undefined;
    var wbuf: [1024]u8 = undefined;

    var client = try Client.init(connection, .{
        .reader_buffer = &rbuf,
        .writer_buffer = &wbuf,
    });
    defer client.close();

    const allocator = std.heap.page_allocator;

    var w = azync.Worker.init(allocator, client);

    _ = try w.addTask("test", testTaskFn);
    _ = try w.addTask("count", count);
    _ = try w.run();
}

pub fn testTaskFn(target: []const u8) void {
    std.debug.print("testing; {s}\n", .{target});
}

pub fn count(target: []const u8) void {
    const parsed = std.fmt.parseInt(i32, target, 10) catch |err| {
        std.debug.print("invalid int: {s}\n", .{@errorName(err)});
        return;
    };

    for (0..@intCast(parsed)) |i| {
        std.debug.print("{d}\n", .{i});
    }
}
