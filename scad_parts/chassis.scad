module chassis_base(size, angle) {
    difference() {
        square(size, true);

        union() {
            translate([size[0]/2,size[1]/2,0]) rotate([0,0,45]) square(angle, true);
            translate([size[0]/2,-size[1]/2,0]) rotate([0,0,45]) square(angle, true);

            translate([-size[0]/2,size[1]/2,0]) rotate([0,0,45]) square(angle, true);
            translate([-size[0]/2,-size[1]/2,0]) rotate([0,0,45]) square(angle, true);
        }
    }
}

module chassis_bottom() {
    union() {
        linear_extrude(height=base_thickness) chassis_base(chassis_size, chassis_corner_angle);

        translate([0,0,base_thickness]) linear_extrude(height=wall_height) difference() {
            chassis_base(chassis_size, chassis_corner_angle);
            offset(delta=-wall_thickness) chassis_base(chassis_size, chassis_corner_angle);
        }
    }
}

module chassis_mid() {
    linear_extrude(height=base_thickness) chassis_base(cover_size, 5);
}