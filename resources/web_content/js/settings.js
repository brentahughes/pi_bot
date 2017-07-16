$(document).ready(function() {
    // If any form element changes bring submit button back to active.
    $('#settings-form :input').change(function() {
        var submitButton =  $('#settings-form :submit');
        if (submitButton != $(this)) {
            submitButton.removeClass('btn-success');
            submitButton.removeClass('btn-default');
            submitButton.addClass('btn-primary');
            submitButton.prop('disabled', false);
            submitButton.val("Save");
        }
    });

    $('#settings-form').on('submit', function(e) {
        var submitButton = $("#" + $(this).attr('id') + " :submit");
        submitButton.prop('disabled', true);
        submitButton.toggleClass('btn-primary btn-default');
        submitButton.val("Saving");

        $.ajax({
            type: $(this).attr('method'),
            url: $(this).attr('action'),
            data: $(this).serializeArray(),
            success: function(data) {
                submitButton.toggleClass('btn-default btn-success');
                submitButton.val("Saved");
            },
            error: function(data) {
                submitButton.removeClass('btn-default');
                submitButton.addClass('btn-primary');
                submitButton.val("Save");
                submitButton.prop('disabled', false);
            }
        });

        e.preventDefault();
    });
});