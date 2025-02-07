const std = @import("std");
const expect = std.testing.expect;
const simState = @import("simState.zig").simState;
const Constants = @import("simConstants.zig").simConstants.init(0.000875, 1000.0);
const kayMath = @import("KayMath.zig");

fn calculateGrashofNumber(simData: *simState) f64 {
    return (Constants.gravity * simData.waterCoeffOfExpansion * (simData.coreTemp - simData.waterTemp) * kayMath.pow(Constants.rpvHeight, 3)) / kayMath.pow(Constants.kineticViscosity, 2);
}

fn densityEquation(temp: f32, baselineDensity: f32) f64 {
    return baselineDensity + (0.0732 * temp) - (0.0089 * kayMath.pow(temp, 2)) + (0.000073413 * kayMath.pow(temp, 3)) - (0.000000474639 * kayMath.pow(temp, 4)) + (0.00000000134888 * kayMath.pow(temp, 5)) - (0.0000000000014 * kayMath.pow(temp, 6));
}

fn calculateReynoldsNumber(simData: *simState) f64 {
    const area = kayMath.cylArea(Constants.rpvWidth / 2) - kayMath.cylArea(Constants.coreWidth / 2);
    const density = densityEquation(simData.waterTemp, Constants.density);
    const flowRate: f64 = (simData.forcedCoreFlow / density) / area; //need to convert kg/s to m3/s and then to m/s
    return (flowRate * Constants.rpvHeight) / Constants.kineticViscosity;
}

pub fn main() !void {
    var simData = simState.init();
    simData.coreTemp = 100.0;
    simData.waterTemp = 20.0;
    std.debug.print("Grashof number: {}\n", .{calculateGrashofNumber(&simData)});
}

test "power" {
    try expect(kayMath.pow(2.0, 0) == 1.0);
    try expect(kayMath.pow(2.0, 1) == 2.0);
    try expect(kayMath.pow(2.0, 2) == 4.0);
    try expect(kayMath.pow(2.0, 3) == 8.0);
    try expect(kayMath.pow(2.0, 4) == 16.0);
}

test "grashof" {
    var simData = simState.init();
    simData.coreTemp = 100.0;
    simData.waterTemp = 20.0;
    try expect(calculateGrashofNumber(&simData) > 0.0);
}

test "density" {
    try expect(densityEquation(-4.0, Constants.density) > 999.0);
    try expect(densityEquation(0.0, Constants.density) > 999.0);
    try expect(densityEquation(4.0, Constants.density) > 999.0);
    try expect(densityEquation(50.0, Constants.density) > 987.0);
    try expect(densityEquation(100.0, Constants.density) > 956.0);
    std.debug.print("Density at 280c: {d}\n", .{densityEquation(280.0, Constants.density)});
    try expect(densityEquation(280.0, Constants.density) > 0);
}

test "reynolds" {
    var simData = simState.init();
    simData.forcedCoreFlow = 100.0;
    simData.waterTemp = 20.0;
    try expect(calculateReynoldsNumber(&simData) > 0.0);
    std.debug.print("Reynolds number: {d}\n", .{calculateReynoldsNumber(&simData)});
}
