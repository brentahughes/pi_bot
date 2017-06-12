use <utilities.scad>;
include <mounts.scad>;
include <chassis.scad>;

// Chassis Information
chassis_size = [170, 80];
base_thickness = 2;
wall_thickness = 2;
wall_height = 3;
wheel_diameter = 65;
wheel_well_depth = 10; // Slightly less than the wheel depth

// Mount information
pi_zero_dim = [65, 30];
motor_controller_dim = [56, 51];

// Curve smoothness
$fn=45; // This can greatly increase render time

module pi_mount() {
    basic_mount(pi_zero_dim, [2,6], 3.5);
}

module motor_controller_mount() {
    basic_mount(motor_controller_dim, [3,7], 5.75);
}

module pi_bot() {
    union() {
        chassis();
        rotate([0,0,90]) pi_mount();
        translate([chassis_size[0]/3-8,0,0]) motor_controller_mount();
        translate([-chassis_size[0]/3+8,0,0]) motor_controller_mount();
    }
}

pi_bot();

// chassis();
// motor_controller_mount();
//

