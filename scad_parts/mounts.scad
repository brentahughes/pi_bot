function sq2poly(size) = [[0,0], [0,size[1]], [size[0],size[1]], [size[0],0]];

// Screw hole and standoff
module mount_standoff(inner, outer, brace_count = 2, brace_size = 8) {
    rotate([0,0,-90]) union() {
        difference() {
            cylinder(d=outer, h=wall_height);
            cylinder(d=inner, h=wall_height+1);
        }

        // Add in stand off corner supports
        for (i = [0:brace_count-1]) {
            rotate([0,0,i*90]) translate([-1.5,brace_size+2,0]) rotate([180,-90,0])
                linear_extrude(height=3)
                    polygon(points = [[0,0], [0,brace_size], [wall_height,brace_size], [0,0]]);
        }
    }
}

// The mounting plate
module basic_mount(dim, standoff_size, hole_inset, brace_count = 4) {
    translate([-dim[0]/2, -dim[1]/2, 0]) difference() {
        union() {
            linear_extrude(height=base_thickness) {
                offset(delta=wall_thickness) square(dim);
            }

            // Add the wall
            translate([0,0,base_thickness]) linear_extrude(height=wall_height/2) {
                difference() {
                    offset(delta=wall_thickness) square(dim);
                    square(dim);
                }
            }

            // Odd the standoffs
            for (x=[0:3]) {
                poly = sq2poly(dim);
                position = poly[x];
                translate([position[0], position[1], 0]) {
                    rotate([0,0,x*-90]) {
                        translate([hole_inset, hole_inset, base_thickness]) {
                            mount_standoff(standoff_size[0], standoff_size[1], brace_count);
                        }
                    }
                }
            }
        }
    }
}

module single_hole_mount(dim, standoff_size, hole_location, brace_count) {
    translate([-dim[0]/2, -dim[1]/2, 0]) {
        union() {
            linear_extrude(height=base_thickness) {
                offset(delta=wall_thickness) square(dim);
            }

            // Add the wall
            translate([0,0,base_thickness]) linear_extrude(height=wall_height/2) {
                difference() {
                    offset(delta=wall_thickness) square(dim);
                    square(dim);
                }
            }

            // Odd the standoff
            translate([hole_location[0], hole_location[1], base_thickness])
                mount_standoff(standoff_size[0], standoff_size[1], brace_count, 4);
        }
    }
}

module pi_mount() {
    basic_mount(pi_zero_dim, pi_zero_standoff_size, pi_zero_hole_inset, 2);
}

module motor_controller_mount() {
    basic_mount(motor_controller_dim, motor_controller_standoff_size, motor_controller_hole_inset, 2);
}

module gearbox_mount() {
    mount_base_thickness = base_thickness+wall_height;
    mount_length = 15;
    mount_width = base_thickness;
    mount_height = gear_box_dim[2]+base_thickness+wall_height;
    mount_hole_base_height = mount_base_thickness + gear_box_mount_diameter/2 + gear_box_hole_distance_from_base;

    union() {
        translate([0,0,base_thickness/2 + wall_height/2])
            cube([gear_box_dim[0], gear_box_dim[1], mount_base_thickness], true);

        translate([0, gear_box_dim[1]/2, 0]) {
            difference() {
                translate([0,mount_width/2,mount_height/2]) cube([mount_length, mount_width, mount_height], true);

                translate([0,base_thickness/2,mount_hole_base_height])
                    rotate([90,0,0])
                        cylinder(r=gear_box_mount_diameter/2, h=base_thickness*3, center=true);

                translate([0,base_thickness/2, mount_hole_base_height + gear_box_mount_hole_spacing])
                    rotate([90,0,0])
                        cylinder(r=gear_box_mount_diameter/2, h=base_thickness*3, center=true);
            }
        }

        translate([-base_thickness/2 + mount_length/2,gear_box_dim[1]/2 + mount_width*wall_height/2,mount_height/2])
            cube([base_thickness, wall_height, mount_height], true);

        translate([base_thickness/2 - mount_length/2,gear_box_dim[1]/2 + mount_width*wall_height/2,mount_height/2])
            cube([base_thickness, wall_height, mount_height], true);
    }
}

module ir_sensor_mount() {
    union () {
        linear_extrude(height=base_thickness) square(ir_proximity_dim, true);

        translate([0,ir_proximity_dim[1]/2 + wall_thickness/2,(base_thickness + wall_height+2)/2])
            cube([ir_proximity_dim[0], wall_thickness, base_thickness + wall_height+2], true);

        translate([0,-ir_proximity_dim[1]/2 - wall_thickness/2,(base_thickness + wall_height+2)/2])
            cube([ir_proximity_dim[0], wall_thickness, base_thickness + wall_height+2], true);

        translate([ir_proximity_dim[0]/2 - ir_proximity_hole_location,0,base_thickness])
            mount_standoff(ir_proximity_standoff_size[0], ir_proximity_standoff_size[1], 4, ir_proximity_dim[1]/3);
    }
}

module battery_mount() {
    battery_to_edge = (cover_size[1] - battery_dim[1] - wall_thickness*2) / 2;

    union() {
        translate([0,0,base_thickness/2]) cube([cover_size[0], cover_size[1], base_thickness], true);

        translate([-(cover_size[0]/2 - battery_dim[0]/2 - wall_thickness),0,0]) {
            linear_extrude(height=base_thickness) {
                difference() {
                    offset(delta=wall_thickness) square([battery_dim[0], battery_dim[1]], true);
                    translate([battery_dim[0]/2 - 20, 0, 0]) square([50, battery_dim[1]], true);
                }
            }

            translate([0,0,base_thickness]) linear_extrude(height=battery_dim[2]/2) difference() {
                offset(delta=wall_thickness) square([battery_dim[0], battery_dim[1]], true);
                square([battery_dim[0], battery_dim[1]], true);
                translate([wall_thickness*2, 0, 0]) square([battery_dim[0], battery_dim[1]], true);
            }
        }
    }
}