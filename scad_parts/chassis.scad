module chassis_base() {
    chassis_size_poly = sq2poly(chassis_size);

    translate([-chassis_size[0]/2, -chassis_size[1]/2]) difference() {
        square(chassis_size);

        union() {
            for (point = chassis_size_poly) {
                new_x = [for (i = [0]) if (point[i] > 0) point[i] - wheel_diameter else point[i]];
                new_y = [for (i = [1]) if (point[i] > 0) point[i] - wheel_well_depth else point[i]];
                new_point = concat(new_x, new_y);

                translate(new_point) square([wheel_diameter, wheel_well_depth]);
            }
        }
    }
}

module chassis() {
    translate([0,0,-base_thickness/2 - wall_height/2]) union() {
        linear_extrude(height=base_thickness) chassis_base();

        translate([0,0,base_thickness]) linear_extrude(height=wall_height, center=false) difference() {
            chassis_base();
            offset(delta=-wall_thickness) chassis_base();
        }
    }
}
