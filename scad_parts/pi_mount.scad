pi_zero_dim = [65, 30];

// Screw hole and standoff for the raspberry pi
module pi_standoff() {
    rotate([0,0,-90]) union() {
        difference() {
            cylinder(d=6, h=wall_height+1);
            translate([0,0,-.5]) cylinder(d=2, h=wall_height+2);
        }

        // Add in stand off corner supports
        translate([-2,10,0]) rotate([180,-90,0])
            linear_extrude(height=4) polygon([[0,0], [0,8], [wall_height+1,8], [0,0]]);

        translate([-10,-2,0]) rotate([180,-90,90])
            linear_extrude(height=4) polygon([[0,0], [0,8], [wall_height+1,8], [0,0]]);
    }
}

// The mounting plate for the raspberry pi
module pi_mount() {
    hole_inset=3.5; // Distance from corners of plate


    translate([wall_thickness, wall_thickness, 0]) difference() {
        union() {
            linear_extrude(height=base_thickness) {
                offset(delta=wall_thickness) square(pi_zero_dim);
            }

            // Add the wall
            translate([0,0,base_thickness]) linear_extrude(height=wall_height) {
                difference() {
                    offset(delta=wall_thickness) square(pi_zero_dim);
                    square(pi_zero_dim);
                }
            }

            // Odd the standoffs
            for (x=[0:3]) {
                pi_zero_poly = sq2poly(pi_zero_dim);
                position = pi_zero_poly[x];
                translate([position[0], position[1], base_thickness]) {
                    rotate([0,0,x*-90]) {
                        translate([hole_inset, hole_inset, 0]) {
                            pi_standoff();
                        }
                    }
                }
            }

            // Add text
            translate([6,10,base_thickness]) linear_extrude(height=.6) text("Pi Zero", size=12);
        }
    }
}