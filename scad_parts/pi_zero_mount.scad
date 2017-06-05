$fn = 45;

// Screw hole and standoff for the raspberry pi
module pi_standoff() {
    rotate([0,0,-90]) union() {
        difference() {
            cylinder(d=4.5, h=4);
            translate([0,0,-.5]) cylinder(d=2, h=5);
        }

        translate([-1,10,0]) rotate([180,-90,0]) linear_extrude(height=2) polygon([[0,0], [0,8], [3,8], [0,0]]);
        translate([-10,-1,0]) rotate([180,-90,90]) linear_extrude(height=2) polygon([[0,0], [0,8], [3,8], [0,0]]);
    }
}

// The mounting plate for the raspberry pi
module pi_mount() {
    hole_inset=5.5; // Distance from corners of plate

    difference() {
        union() {
            pi_zero_dim = [[0,0], [0,34], [69,34], [69,0]];
            linear_extrude(height=base_thickness) {
                polygon(pi_zero_dim);
            }

            translate([0,0,base_thickness]) linear_extrude(height=1) {
                difference() {
                    polygon(pi_zero_dim);
                    offset(delta=-1) polygon(pi_zero_dim);
                }

            }

            for (x=[0:3]) {
                position = pi_zero_dim[x];
                translate([position[0],position[1],base_thickness]) {
                    rotate([0,0,x*-90]) {
                        translate([hole_inset, hole_inset, 0]) {
                            pi_standoff(base_thickness);
                        }
                    }
                }
            }

            translate([8,12,base_thickness]) linear_extrude(height=.4) text("Pi Zero", size=12);
        }
    }
}