// Front bumper of chassis plate
module chassis_front() {
    union() {
        translate([0,10,0]) cube([100,10, base_thickness], true);
        intersection() {
            cube([100, 10, base_thickness], true);
            translate([0,45,0]) scale([1.7,1,1]) cylinder(d=100, h=base_thickness, center=true);
        }
    }
}

// One quarter of the main chassis base
module chassis_wheel_base_section() {
    wall_height = 2;
    full_base_size = [[0,0], [50,0], [50,120], [0,120]];
    wheel_well_size = [[0,0], [20,0], [20,70], [0,70]];

    // Build plate
    linear_extrude(height=base_thickness) difference() {
        polygon(full_base_size);
        translate([30, 40]) polygon(wheel_well_size);
    }
}

// Core of chassis plate
module chassis_wheel_base() {
    // Build the main base
    chassis_wheel_base_section();
    mirror([1,0,0]) chassis_wheel_base_section();
    mirror([0,1,0]) chassis_wheel_base_section();
    mirror([1,0,0]) mirror([0,1,0]) chassis_wheel_base_section();
}

// The main chassis plate
module chassis_base() {
    union() {
        translate([0,135,base_thickness/2]) rotate([0,0,180]) chassis_front();
        chassis_wheel_base();
    }
}

module chassis() {
    union() {
        chassis_base();

        translate([0,0,base_thickness]) linear_extrude(height=2) difference() {
            projection(cut=true) chassis_base();
            offset(delta=-2) projection(cut=true) chassis_base();
        }
    }
}
