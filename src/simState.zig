pub const simState = struct {
    naturalCoreFlow: f64, //kg/s
    forcedCoreFlow: f64, //kg/s
    coreTemp: f32, //c
    waterTemp: f32, //c
    feedTemp: f32, //c
    steamTemp: f32, //c
    waterCoeffOfExpansion: f32, //1/c //TODO: Account for change of this with temperature region,

    pub fn init() simState {
        return simState{ .naturalCoreFlow = 0, .forcedCoreFlow = 0.0, .coreTemp = 0.0, .waterTemp = 0.0, .feedTemp = 0.0, .steamTemp = 0.0, .waterCoeffOfExpansion = 0.000214 };
    }
};
