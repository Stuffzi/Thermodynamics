const std = @import("std");
const expect = std.testing.expect;
const simState = @import("simState.zig").simState;
const Constants = @import("simConstants.zig").simConstants.init(0.000875, 1000.0);
const kayMath = @import("KayMath.zig");

fn densityEquation(temp: f32, baselineDensity: f32) f64 {
    return baselineDensity + (0.0732 * temp) - (0.0089 * kayMath.pow(temp, 2)) + (0.000073413 * kayMath.pow(temp, 3)) - (0.000000474639 * kayMath.pow(temp, 4)) + (0.00000000134888 * kayMath.pow(temp, 5)) - (0.0000000000014 * kayMath.pow(temp, 6));
}

fn thermalDiffusivityEquation(temp: f32) f64 {
    return ((1 - (0.1343 / 31328)) * kayMath.pow(temp - 177.0, 2)) + 0.1741;
}

fn calculateRayleighNumber(simData: *simState) f64 {
    return (Constants.gravity * simData.waterCoeffOfExpansion * (simData.coreTemp - simData.waterTemp) * kayMath.pow(Constants.rpvHeight, 3)) / kayMath.pow(Constants.kineticViscosity, 2);
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
    std.debug.print("Grashof number: {}\n", .{calculateRayleighNumber(&simData)});
}
