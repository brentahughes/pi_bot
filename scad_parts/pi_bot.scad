use <utilities.scad>;

include <pi_zero_mount.scad>;
include <pi_bot_chassis.scad>;

$fn=45;
base_thickness = 2;
wall_thickness = 2;
wall_height = 2;

module pi_bot() {
    chassis();
    rotate([0,0,-90]) translate([-(pi_zero_dim[0]+wall_thickness)/2, -pi_zero_dim[1]-14, 0]) pi_mount();
}


pi_bot();
// pi_mount();
