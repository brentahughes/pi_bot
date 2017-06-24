use <utilities.scad>;
include <mounts.scad>;
include <chassis.scad>;

// Chassis Information
chassis_size = [160, 90];
chassis_corner_angle = 15;
base_thickness = 2;
wall_thickness = 1;
wall_height = 2;

gear_box_dim = [66,18.5,24];
gear_box_mount_diameter = 3;

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

        x_gear_box_translate = chassis_size[0]/2 - gear_box_dim[0]/2 - chassis_corner_angle/2 - wall_thickness*3;
        y_gear_box_translate = chassis_size[1]/2-gear_box_dim[1]/2;

        translate([x_gear_box_translate,y_gear_box_translate,0])
            rotate([0,0,180]) gearbox_mount(gear_box_dim);

        translate([-x_gear_box_translate,y_gear_box_translate,0])
            rotate([0,0,180]) gearbox_mount(gear_box_dim);

        translate([x_gear_box_translate, -y_gear_box_translate,0])
            gearbox_mount(gear_box_dim);

        translate([-x_gear_box_translate, -y_gear_box_translate,0])
            gearbox_mount(gear_box_dim);
    }
}

pi_bot();
