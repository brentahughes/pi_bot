$(document).ready(function() {
    $('#overview_start_demo').click(function() {
        console.log('here');
    });

    $('.overview_link').click(function() {
        $('.control_link').removeClass('active');
        $('.settings_link').removeClass('active');
        $(this).addClass('active');
    });

    $('.control_link').click(function() {
        $('.overview_link').removeClass('active');
        $('.settings_link').removeClass('active');
        $(this).addClass('active');
    });

    $('.settings_link').click(function() {
        $('.control_link').removeClass('active');
        $('.overview_link').removeClass('active');
        $(this).addClass('active');
    });
});