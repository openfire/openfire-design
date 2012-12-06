
$(document).ready () ->

    $('#notify-me-btn').click () ->

        $('.alert').hide()
        if not $('#notify-me-form').valid()
            $('#notify-invalid').show()
            return
        $('#extra-notify-error').html('')

        postDict =
            name: $("#my-name").val()
            email: $("#my-email").val()
            story: $("#my-story").val()

        $.ajax
            type: 'POST'
            url: '/_api/v1/betanotify/'
            data: JSON.stringify(postDict)
            dataType: 'json'
            contentType: 'application/json'

            success: (response) ->
                $('#notify-success').show()

            error: (response) ->
                $('#extra-notify-error').html(response.responseText)
                $('#notify-error').show()

    $('#notify-me-form').validate(errorPlacement: () -> )
