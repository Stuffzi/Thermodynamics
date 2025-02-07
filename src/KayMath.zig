pub fn pow(base: f64, exponent: i8) f64 {
    if (exponent < 0) {
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

pub fn cylArea(radius: f32) f64 {
    return 3.14159 * pow(@as(f64, radius), 2);
}
