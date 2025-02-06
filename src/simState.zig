pub const simState = struct {
    coreFlow: f64,
    coreTemp: f32,
    waterTemp: f32,
    feedTemp: f32,
    steamTemp: f32,

    pub fn init() SimState {
        return SimState{
            .coreFlow = 0.0,
            .coreTemp = 0.0,
            .waterTemp = 0.0,
            .feedTemp = 0.0,
            .steamTemp = 0.0,
        };
    }
}