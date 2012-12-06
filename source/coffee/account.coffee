## openfire user account page.


class UserAccountPageController

    constructor: () ->

        @init = () =>
            @initChangeEmail()

        @initChangeEmail = () =>
            $('#start-change-email-address-btn').click () ->
                $('#change-email-address-inline').show()
                $('#start-change-email-address-btn').hide()

            $('#cancel-change-email-address-btn').click () ->
                $('#start-change-email-address-btn').show()
                $('#change-email-address-inline').hide()

            $('#save-change-email-address-btn').click () ->
                postData = 'email=' + $('#change-email-address-input').val()
                $('#change-email-address-inline-success').hide()
                $('#change-email-address-inline-error').html('').hide()
                $.ajax
                    type: 'POST',
                    url: '/account/email/resend_confirm/',
                    data: postData,
                    success: (response) =>
                        $('#change-email-address-inline-success').show()
                    error: (response) =>
                        $('#change-email-address-inline-error').html(response.responseText).show()


window.UserAccountPageController = UserAccountPageController
$.openfire.controller_classes.user_account_page = UserAccountPageController
