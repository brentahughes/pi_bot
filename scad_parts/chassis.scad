module chassis_base() {
    difference() {
        square(chassis_size, true);

        union() {
            translate([chassis_size[0]/2,chassis_size[1]/2,0]) rotate([0,0,45]) square(chassis_corner_angle, true);
            translate([chassis_size[0]/2,-chassis_size[1]/2,0]) rotate([0,0,45]) square(chassis_corner_angle, true);

            translate([-chassis_size[0]/2,chassis_size[1]/2,0]) rotate([0,0,45]) square(chassis_corner_angle, true);
            translate([-chassis_size[0]/2,-chassis_size[1]/2,0]) rotate([0,0,45]) square(chassis_corner_angle, true);
        }
    }
}

module chassis() {
    union() {
        linear_extrude(height=base_thickness) chassis_base();

        translate([0,0,base_thickness]) linear_extrude(height=wall_height) difference() {
            chassis_base();
            offset(delta=-wall_thickness) chassis_base();
        }
    }
}
