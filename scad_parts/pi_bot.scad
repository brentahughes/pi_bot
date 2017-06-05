include <pi_zero_mount.scad>;
include <pi_bot_chassis.scad>;

$fn=45;
base_thickness = 2;

module pi_bot() {
    chassis();
    rotate([0,0,-90]) translate([-34.5,10,]) pi_mount();
}

pi_bot();
