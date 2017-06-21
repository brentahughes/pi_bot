use <utilities.scad>;
include <mounts.scad>;
include <chassis.scad>;

// Chassis Information
chassis_size = [170, 90];
base_thickness = 2;
wall_thickness = 1;
wall_height = 2;

gear_box_dim = [66,18.5,22.5];

// Mount information
pi_zero_dim = [65, 30];
pi_zero_hole_inset = 3.5;
pi_zero_standoff_size = [2,6];

motor_controller_dim = [43, 43];
motor_controller_hole_inset = 3.5;
motor_controller_standoff_size = [3,7];

ir_proximity_dim = [31, 14];
ir_proximity_hole_location = [6.5, 7];
ir_proximity_standoff_size = [3,7];

// Curve smoothness
$fn=45; // This can greatly increase render time

module pi_bot() {
    union() {
        chassis();
        pi_mount();

        motor_controller_translate = [chassis_size[0]/2-motor_controller_dim[0]/2-wall_thickness*2,0,0];
        for (i = [-1,1]) {
            translate(i*motor_controller_translate) motor_controller_mount();
        }

        translate([gear_box_dim[0]/2+7,chassis_size[1]/2-gear_box_dim[1]/2,0])
            rotate([0,0,180]) gearbox_mount(gear_box_dim);

        translate([-gear_box_dim[0]/2-7,chassis_size[1]/2-gear_box_dim[1]/2,0])
            rotate([0,0,180]) gearbox_mount(gear_box_dim);

        translate([gear_box_dim[0]/2+7,-chassis_size[1]/2+gear_box_dim[1]/2,0])
            gearbox_mount(gear_box_dim);

        translate([-gear_box_dim[0]/2-7,-chassis_size[1]/2+gear_box_dim[1]/2,0])
            gearbox_mount(gear_box_dim);
    }
}

// motor_controller_mount();
pi_bot();
// gearbox_mount(gear_box_dim);
// basic_mount([20,30], [3,7], 6, 2);
// chassis();
// motor_controller_mount();
//

