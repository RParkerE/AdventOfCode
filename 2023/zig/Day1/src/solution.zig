const std = @import("std");

const Word2NumEntry = struct {
    word: []const u8,
    digit: u8,
};

const word2num = [_]Word2NumEntry{
    .{ .word = "one", .digit = '1' },
    .{ .word = "two", .digit = '2' },
    .{ .word = "three", .digit = '3' },
    .{ .word = "four", .digit = '4' },
    .{ .word = "five", .digit = '5' },
    .{ .word = "six", .digit = '6' },
    .{ .word = "seven", .digit = '7' },
    .{ .word = "eight", .digit = '8' },
    .{ .word = "nine", .digit = '9' },
    .{ .word = "zero", .digit = '0' },
};

var total: usize = 0;

pub fn convert_line(line: []const u8, map: []const Word2NumEntry) ![]u8 {
    const allocator = std.heap.page_allocator;
    var result = try allocator.alloc(u8, line.len);
    errdefer allocator.free(result);

    var result_len: usize = 0;
    var i: usize = 0;
    while (i < line.len) {
        var matched = false;
        for (map) |entry| {
            if (std.mem.startsWith(u8, line[i..], entry.word)) {
                result[result_len] = entry.digit;
                result_len += 1;
                matched = true;
                break;
            }
        }
        if (!matched) {
            result[result_len] = line[i];
            result_len += 1;
        }
        i += 1;
    }

    return result[0..result_len];
}

pub fn get_digits(line: []const u8) !?u32 {
    var first_val: ?u8 = null;
    var last_val: ?u8 = null;
    for (line) |c| {
        if (std.ascii.isDigit(c)) {
            if (first_val == null) {
                first_val = c;
            }
            last_val = c;
        }
    }

    if (first_val != null and last_val != null) {
        const value = try std.fmt.parseInt(u32, &[_]u8{ first_val.?, last_val.? }, 10);
        return value;
    }

    return null;
}

pub fn process_file(filename: []const u8, map: []const Word2NumEntry) !usize {
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var val: usize = 0;
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("Original line: {s}\n", .{line});
        const new_line = try convert_line(line, map);
        defer std.heap.page_allocator.free(new_line);
        std.debug.print("Converted line: {s}\n", .{new_line});

        if (try get_digits(new_line)) |digits| {
            std.debug.print("Extracted digits: {}\n", .{digits});
            val += digits;
        }
        std.debug.print("Running total: {}\n\n", .{val});
    }
    return val;
}

pub fn main() !void {
    total = process_file("../../../day1_input.txt", &word2num) catch |err| {
        std.debug.print("Error processing file: {}\n", .{err});
        return err;
    };
    std.debug.print("Total: {}\n", .{total});
}
