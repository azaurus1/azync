const okredis = @import("okredis");
const std = @import("std");

pub const TaskFn = *const fn ([]const u8) void;

pub const Worker = struct {
    redis_client: okredis.Client,
    tasks: std.StringHashMap(TaskFn),

    pub fn init(allocator: std.mem.Allocator, redis_client: okredis.Client) Worker {
        return Worker{ .redis_client = redis_client, .tasks = std.StringHashMap(TaskFn).init(allocator) };
    }

    pub fn deinit(self: *Worker) void {
        self.tasks.deinit();
    }

    pub fn addTask(self: *Worker, name: []const u8, task: TaskFn) !void {
        try self.tasks.put(name, task);
    }

    pub fn run(self: *Worker) !void {
        const allocator = std.heap.page_allocator;

        while (true) {
            const resp = try self.redis_client.sendAlloc([][]const u8, allocator, .{ "BRPOP", "myqueue", "0" });
            defer allocator.free(resp);

            if (resp.len == 2) {
                const payload = resp[1];
                if (std.mem.indexOfScalar(u8, payload, '|')) |pos| {
                    const name = payload[0..pos];
                    const arg = payload[pos + 1 ..];

                    if (self.tasks.get(name)) |f| {
                        f(arg);
                    } else {
                        std.debug.print("no task named: {s}\n", .{name});
                    }
                }
            }
        }
    }
};
