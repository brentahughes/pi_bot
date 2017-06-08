use <utilities.scad>;

include <pi_mount.scad>;
include <chassis.scad>;

// Chassis Information
chassis_size = [160, 70];
base_thickness = 2;
wall_thickness = 2;
wall_height = 2;
wheel_diameter = 65;
wheel_well_depth = 10; // Slightly less than the wheel depth

// Curve smoothness
$fn=45; // This can greatly increase render time

module pi_bot() {
    chassis();
    rotate([0,0,-90]) translate([-(pi_zero_dim[0]+wall_thickness)/2, -pi_zero_dim[1]-14, 0]) pi_mount();
}


// pi_bot();
chassis();
// pi_mount();
