module chassis() {
    chassis_size_poly = sq2poly(chassis_size);

    difference() {
        square(chassis_size);

        union() {
            for (point = chassis_size_poly) {
                new_x = [for (i = [0]) if (point[i] > 0) point[i] - wheel_diameter else point[i]];
                new_y = [for (i = [1]) if (point[i] > 0) point[i] - wheel_well_depth else point[i]];
                new_point = concat(new_x, new_y);
                echo(new_point);

                translate(new_point) square([wheel_diameter, wheel_well_depth]);
            }
        }
    }
}
