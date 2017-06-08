use <utilities.scad>;

include <pi_mount.scad>;
include <chassis.scad>;

// Chassis Information
chassis_size = [160, 100];
base_thickness = 2;
wall_thickness = 2;
wall_height = 3;
wheel_diameter = 70;
wheel_well_depth = 10; // Slightly less than the wheel depth

// Curve smoothness
$fn=45; // This can greatly increase render time

module pi_bot() {
    union() {
        chassis();

        // Put the pi mount in the center of the chassis
        rotate([0,0,-90]) pi_mount();
    }
}

pi_bot();
// chassis();
// pi_mount();
