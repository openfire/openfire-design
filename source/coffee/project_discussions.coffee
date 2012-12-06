## openfire project page.


class ProjectDiscussionsPageController

    constructor: () ->

        @newDiscussionDlg = null
        @newDiscussionCommentDlg = null
        @newDiscussionReplyDlg = null

        @init = () =>
            @initDialogs()

        @initDialogs = () =>
            _this = @

            @newDiscussionDlg = $('#new-discussion-dlg').modal(show: false)
            $('#save-new-discussion-btn').click(@saveNewDiscussion)
            $('#close-new-discussion-btn').click () =>
                @newDiscussionDlg.modal('hide')
            $('#new-discussion-btn').click () =>
                @newDiscussionDlg.modal('show')

            @newDiscussionCommentDlg = $('#new-discussion-comment-dlg').modal(show: false)
            $('#save-new-discussion-comment-btn').click(@saveNewDiscussionComment)
            $('#close-new-discussion-comment-btn').click () =>
                @newDiscussionCommentDlg.modal('hide')
            $('.new-discussion-comment-btn').click () ->
                id = this.id.match(/new-discussion-comment-btn-(\d+)/)[1]
                _this.newDiscussionCommentDlg.find('input[name="discussion_id"]').val(id)
                _this.newDiscussionCommentDlg.find('textarea[name="content"]').redactor()
                _this.newDiscussionCommentDlg.modal('show')

            """
            # TODO: Edit comments.
            $('.edit-discussion-comment-btn').click () ->
                id = this.id.match(/edit-discussion-comment-(\d+)/)[1]
                _this.editDiscussionComment(id)
            """

            @newDiscussionReplyDlg = $('#new-discussion-reply-dlg').modal(show: false)
            $('#save-new-discussion-reply-btn').click(@saveNewDiscussionReply)
            $('#close-new-discussion-reply-btn').click () =>
                @newDiscussionReplyDlg.modal('hide')
            $('.new-discussion-reply-btn').click () ->
                id = this.id.match(/new-discussion-reply-btn-(\d+)/)[1]
                _this.newDiscussionReplyDlg.find('input[name="comment_id"]').val(id)
                _this.newDiscussionReplyDlg.find('textarea[name="content"]').redactor()
                _this.newDiscussionReplyDlg.modal('show')

        @saveNewDiscussion = () =>
            postData = $('#new-discussion-frm').serialize()
            postData += "&project_id=" + $.openfire.page_vars.project_id
            $.ajax
                type: 'POST',
                url: '/_api/v1/project_discussion/',
                data: postData,
                success: (response) =>
                    #@newDiscussionDlg.modal('hide')
                    window.location.reload()
                error: (response) =>
                    alert('Error! ' + response.responseText)

        @saveNewDiscussionComment = () =>
            postData = $('#new-discussion-comment-frm').serialize()
            $.ajax
                type: 'POST',
                url: '/_api/v1/project_discussion_comment/',
                data: postData,
                success: (response) =>
                    # Add the new comment to the list on the page.
                    list = $('#discussion-comment-list-' + $('#new-discussion-comment-frm input[name="discussion_id"]').val())
                    el = list.find('.discussion-comment-template').clone()
                            .removeClass('discussion-comment-template')
                            .appendTo(list).show()
                    el.find('.discussion-comment-content').html($('#new-discussion-comment-frm textarea[name="content"]').val())
                    el.find('.discussion-comment-author').html('you')
                    el.find('.discussion-comment-title').html($('#new-discussion-comment-frm input[name="title"]').val())
                    #el.find('.discussion-comment-slug').html($('#new-discussion-comment-frm input[name="slug"]').val())
                    el.find('.discussion-comment-created').html('just now')
                    list.find('.no-comments-item').hide()
                    @newDiscussionCommentDlg.modal('hide')

                error: (response) =>
                    alert('Error saving comment! ' + response.responseText)

        @saveNewDiscussionReply = () =>
            postData = $('#new-discussion-reply-frm').serialize()
            $.ajax
                type: 'POST',
                url: '/_api/v1/project_discussion_reply/',
                data: postData,
                success: (response) =>
                    # Add the new reply to the list on the page.
                    list = $('#discussion-reply-list-' + $('#new-discussion-reply-frm input[name="comment_id"]').val())
                    el = list.find('.discussion-reply-template').clone()
                            .removeClass('discussion-reply-template')
                            .appendTo(list).show()
                    el.find('.discussion-reply-content').html($('#new-discussion-reply-frm textarea[name="content"]').val())
                    el.find('.discussion-reply-author').html('you')
                    el.find('.discussion-reply-created').html('just now')
                    list.find('.no-replies-item').hide()
                    @newDiscussionReplyDlg.modal('hide')

                error: (response) =>
                    alert('Error saving reply! ' + response.responseText)



window.ProjectDiscussionsPageController = ProjectDiscussionsPageController
$.openfire.controller_classes.project_discussions_page = ProjectDiscussionsPageController
