// Screw hole and standoff
module standoff(inner, outter) {
    rotate([0,0,-90]) union() {
        difference() {
            cylinder(d=outter, h=wall_height+1);
            translate([0,0,-.5]) cylinder(d=inner, h=wall_height+2);
        }

        // Add in stand off corner supports
        translate([-1.5,10,0]) rotate([180,-90,0])
            linear_extrude(height=3) polygon([[0,0], [0,8], [wall_height+1,8], [0,0]]);

        translate([-10,-1.5,0]) rotate([180,-90,90])
            linear_extrude(height=3) polygon([[0,0], [0,8], [wall_height+1,8], [0,0]]);
    }
}

// The mounting plate
module basic_mount(dim, standoff_size, hole_inset) {
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
                            standoff(standoff_size[0], standoff_size[1]);
                        }
                    }
                }
            }
        }
    }
}
