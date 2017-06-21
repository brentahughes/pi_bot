// Screw hole and standoff
module mount_standoff(inner, outter, brace_count = 2, brace_size = 8) {
    rotate([0,0,-90]) union() {
        difference() {
            cylinder(d=outter, h=wall_height);
            translate([0,0,-.5]) cylinder(d=inner, h=wall_height+1);
        }

        // Add in stand off corner supports
        for (i = [0:brace_count-1]) {
            rotate([0,0,i*90]) translate([-1.5,brace_size+2,0]) rotate([180,-90,0])
                linear_extrude(height=3) polygon([[0,0], [0,brace_size], [wall_height,brace_size], [0,0]]);
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
                translate([position[0], position[1], base_thickness]) {
                    rotate([0,0,x*-90]) {
                        translate([hole_inset, hole_inset, 0]) {
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

module gearbox_mount(dim) {
    translate([0,0,base_thickness/2 + wall_height/2]) cube([dim[0], dim[1], base_thickness+wall_height], true);

    translate([-20, dim[1]/2, base_thickness]) rotate([90,0,0]) {
        linear_extrude(height=wall_height) {
            difference() {
                hull() {
                    square([40,wall_height]);
                    translate([15, dim[2]+wall_height, 0]) square([10,1]);
                }

                translate([20,wall_height+2,0]) circle(r=1.5);
                translate([20,dim[2]-2,0]) circle(r=1.5);
            }
        }

        translate([0,0,-wall_height]) linear_extrude(height=wall_height*2) difference() {
            hull() {
                square([40,wall_height]);
                translate([15, dim[2]+wall_height, 0]) square([10,1]);
            }

            offset(delta=-wall_height) hull() {
                square([40,1]);
                translate([15, dim[2]+2, 0]) square([10,1]);
            }
        }
    }
}