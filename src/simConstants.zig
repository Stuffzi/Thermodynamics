pub const simConstants = struct {
    gravity: f16 = 9.8, //m/s2
    density: f32 = 1000.0, //kg/m3
    dynamicViscosity: f32 = 0.000875, //pa/s
    kineticViscosity: f32, //m2/s
    rpvHeight: f16 = 15.0, //m
    rpvWidth: f16 = 5.0, //m
    coreHeight: f16 = 3.5, //m

    pub fn init(dynamicViscosity: f32, density: f32) simConstants {
        return simConstants{
            .kineticViscosity = dynamicViscosity / density,
        };
    }
};
