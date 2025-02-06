const std = @import("std");
const expect = std.testing.expect;
const simState = @import("simState.zig").simState;
const simConstants = @import("simConstants.zig").simConstants.init(0.000875, 1000.0);

fn pow(base: f64, exponent: i8) f64 {
    if (exponent < 0) {
        std.debug.print("Err: negative exponent", .{});
        return -1.0;
    }

    var result: f64 = 1;
    var iterator: i8 = 0;
    while (iterator < exponent) {
        result *= base;
        iterator += 1;
    }
    return result;
}

fn calculateGrashofNumber(simData: *simState) f64 {
    return (simConstants.gravity * simData.waterCoeffOfExpansion * (simData.coreTemp - simData.waterTemp) * pow(simConstants.rpvHeight, 3)) / pow(simConstants.kineticViscosity, 2);
}

pub fn main() !void {}

test "power" {
    try expect(pow(2.0, 0) == 1.0);
    try expect(pow(2.0, 1) == 2.0);
    try expect(pow(2.0, 2) == 4.0);
    try expect(pow(2.0, 3) == 8.0);
    try expect(pow(2.0, 4) == 16.0);
}

test "grashofSanity" {
    var simData = simState.init();
    simData.coreTemp = 100.0;
    simData.waterTemp = 20.0;
    try expect(calculateGrashofNumber(&simData) > 0.0);
}
