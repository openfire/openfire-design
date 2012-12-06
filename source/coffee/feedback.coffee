# openfire feedback controller.

class FeedbackController

    constructor: () ->

        @slider = null

        @init = () =>
            $('#show-feedback-btn').click(@showFeedback)
            $('#hide-feedback-btn').click(@hideFeedback)
            $('#submit-feedback-btn').click(@submitFeedback)

        @showFeedback = () =>
            $('#footer-container').height('300px')
            $('body').animate(scrollTop: $(document).height(), 'easeOutQuint')
            $('#show-feedback-btn').hide()
            $('#hide-feedback-btn').show()

        @hideFeedback = () =>
            $('#footer-container').animate(height: '30px', 'easeOutQuint')
            $('#hide-feedback-btn').hide()
            $('#show-feedback-btn').show()

        @submitFeedback = () =>
            postData = 'feedback=' + encodeURIComponent($('#feedback-content').val())

            $('#feedback-saved').hide()
            $('#feedback-error').html('').hide()
            $.ajax
                type: 'POST'
                url: '/_api/v1/feedback/'
                data: postData
                success: (response) =>
                    $('#feedback-saved').show()
                    $('#submit-feedback-btn').attr('disabled', 'disabled')
                    $('#submit-feedback-btn').addClass('disabled')
                error: (response) =>
                    $('#feedback-error').html(response.responseText).show()

window.FeedbackController = FeedbackController
$.openfire.controller_classes.feedback = FeedbackController
