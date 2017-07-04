include <chassis.scad>;
include <mounts.scad>;

/////////////////////////
// CUSTOMIZABLE THINGS //
/////////////////////////

// Global information
base_thickness = 3; // Default: 3
wall_thickness = 2; // Default: 2
wall_height = 3; // Default: 3

// Chassis information
chassis_size = [170, 105];
chassis_corner_angle = 15;

// Motor and gearbox information
gear_box_dim = [66,18.5,24];
gear_box_mount_diameter = 3.5;
gear_box_hole_distance_from_base = .75;
gear_box_mount_hole_spacing = 18;

// Mount information
pi_zero_dim = [65, 30];
pi_zero_hole_inset = 3.5;
pi_zero_standoff_size = [2.5,6];

motor_controller_dim = [44, 44];
motor_controller_hole_inset = 3.5;
motor_controller_standoff_size = [3,7];

ir_proximity_dim = [31, 15];
ir_proximity_height = 7;
ir_proximity_hole_location = 7;
ir_proximity_standoff_size = [3,7];

battery_dim = [140, 65, 22];

plate_hole_diameter = 3.5;

tallest_component_height = 27; // Usually the heatsink of the motor controller

// Curve smoothness
$fn=45; // This can greatly increase render time

////////////////////////////////////////////
// DO NOT CHANGE ANYTHING BELOW THIS LINE //
////////////////////////////////////////////

// Standoff information
level_one_height = tallest_component_height + wall_height*2 + ir_proximity_height;

// Get the hood size based on the chassis size.
cover_size = [chassis_size[0] - 5, chassis_size[1] - 20];

standoff_translate = [
    cover_size[0]/2 - 2.5 - 5,
    cover_size[1]/2 - 2.5 - 5
];

module plate_standoff(height) {
    inner_hole_depth = max(height / 5, 12);

    difference() {
        cylinder(d=7, h=height, $fn=6);
        cylinder(d=3, h=inner_hole_depth, $fn=45);
        translate([0,0,height - inner_hole_depth]) cylinder(d=3, h=inner_hole_depth);
    }
}

// Primary plate that everything is build on top of.
module bottom_plate() {
    difference() {
        union() {
            // Bring in the base plate to build on top of.
            chassis_bottom();

            // Add the pi mount and move to the side slightly to make room for usb cables.
            translate([
                chassis_size[0]/2 - pi_zero_dim[0]/2 - wall_thickness,
                -(motor_controller_dim[1]/2 - pi_zero_dim[1]/2),
                0
            ])
                pi_mount();

            // Add the motor controller mount
            translate([-(chassis_size[0]/2-motor_controller_dim[0]/2-wall_thickness),0,0]) motor_controller_mount();

            // Add in the motor mounts
            x_gear_box_translate = chassis_size[0]/2 - gear_box_dim[0]/2 - chassis_corner_angle/2 - wall_thickness * 3;
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

        union() {
            translate([standoff_translate[0],standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([standoff_translate[0],-standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([-standoff_translate[0],-standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([-standoff_translate[0],standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([0,-standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([0,standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
        }
    }
}

module mid_plate_base() {
    difference() {
        chassis_mid();

        union() {
            translate([standoff_translate[0],standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([standoff_translate[0],-standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([-standoff_translate[0],-standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([-standoff_translate[0],standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([0,-standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);
            translate([0,standoff_translate[1],0]) cylinder(d=plate_hole_diameter, h=base_thickness*2);

            // Cut a notch in end for cables to run from battery.
            translate([cover_size[0]/2 - 20,0,0]) {
                linear_extrude(height=base_thickness) {
                    hull() {
                        square([1, 5], true);
                        translate([15, 0, 0]) square([10, 15], true);
                    }
                }
            }
        }
    }
}

module middle_plate() {
    ir_standoff_translate = [
        cover_size[0]/2 - ir_proximity_dim[0]/2,
        cover_size[1]/2 - ir_proximity_dim[1]/2 - cover_size[1]/6,
        0
    ];

    union() {
        mid_plate_base();

        translate(ir_standoff_translate)
            rotate([0,0,180]) ir_sensor_mount();

        translate([ir_standoff_translate[0], -ir_standoff_translate[1], ir_standoff_translate[2]])
            rotate([0,0,180]) ir_sensor_mount();

        translate([-ir_standoff_translate[0], -ir_standoff_translate[1], ir_standoff_translate[2]])
            ir_sensor_mount();

        translate([-ir_standoff_translate[0], ir_standoff_translate[1], ir_standoff_translate[2]])
            ir_sensor_mount();
    }
}

module top_plate() {
    union() {
        mid_plate_base();
        battery_mount();
    }
}

module pi_bot() {
    union() {
        bottom_plate();

        translate([standoff_translate[0],standoff_translate[1],base_thickness]) plate_standoff(level_one_height);
        translate([standoff_translate[0],-standoff_translate[1],base_thickness]) plate_standoff(level_one_height);
        translate([-standoff_translate[0],-standoff_translate[1],base_thickness]) plate_standoff(level_one_height);
        translate([-standoff_translate[0],standoff_translate[1],base_thickness]) plate_standoff(level_one_height);
        translate([0,-standoff_translate[1],base_thickness]) plate_standoff(level_one_height);
        translate([0,standoff_translate[1],base_thickness]) plate_standoff(level_one_height);

        translate([0,0,level_one_height+base_thickness*2]) rotate([180, 0, 0]) middle_plate();
        translate([0,0,level_one_height+base_thickness*2]) top_plate();
    }
}

// pi_bot();
// motor_controller_mount();
// middle_plate();
// top_plate();
// battery_mount();
// ir_sensor_mount();
bottom_plate();
// gearbox_mount();
// plate_standoff(level_one_height);
