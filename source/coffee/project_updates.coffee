## openfire project page.


class ProjectUpdatesPageController

    constructor: () ->

        @updateEditorDlg = null
        @updateFields = ['id', 'slug', 'title', 'content', 'published']
        @richContentFields = ['content']
        @booleanFields = ['published']

        @init = () =>
            @initUpdateDlg()
            @initUpdateComments()

        @initUpdateDlg = () =>
            _this = @
            @updateEditorDlg = $('#update-editor-dlg').modal(show: false)
            $('#save-project-update-btn').click(@saveProjectUpdate)
            $('#close-project-update-btn').click () =>
                @updateEditorDlg.modal('hide')
            $('#new-project-update').click(@newProjectUpdate)
            $('.edit-project-update-btn').click () ->
                id = this.id.match(/edit-project-update-(\d+)/)[1]
                _this.editProjectUpdate(id)

        @initUpdateComments = () =>
            _this = @
            $('.add-update-comment-btn').click () ->
                id = this.id.match(/add-update-comment-(\d+)/)[1]
                inline = $('#project-update-inline-' + id)
                inline.find('.editor-field').redactor().setCode('')
                inline.show()

            $('.cancel-update-comment-btn').click () ->
                id = this.id.match(/cancel-update-comment-(\d+)/)[1]
                $('#project-update-inline-' + id).hide()

            $('.save-update-comment-btn').click () ->
                id = this.id.match(/save-update-comment-(\d+)/)[1]
                content = $('#project-update-inline-' + id + ' .editor-field').redactor().getCode()
                _this.saveUpdateComment(id, content)

        @newProjectUpdate = () =>
            for field in @updateFields
                if field in @richContentFields
                    $('#project-update-' + field + '-input').redactor().setCode('')
                else if field in @booleanFields
                    $('#project-update-' + field + '-input').removeAttr('checked')
                else
                    $('#project-update-' + field + '-input').val('')
            $('#project-update-slug-input').removeAttr('disabled')
            @updateEditorDlg.modal('show')

        @editProjectUpdate = (id) =>
            for field in @updateFields
                if field in @richContentFields
                    $('#project-update-' + field + '-input').redactor().setCode($('#project-update-' + id + '-' + field).html())
                else if field in @booleanFields
                    if $('#project-update-' + id + '-' + field).html() == 'true'
                        $('#project-update-' + field + '-input').attr('checked', 'checked')
                    else
                        $('#project-update-' + field + '-input').removeAttr('checked')
                else
                    $('#project-update-' + field + '-input').val($('#project-update-' + id + '-' + field).html())
            $('#project-update-slug-input').attr('disabled', 'disabled')
            @updateEditorDlg.modal('show')

        @saveProjectUpdate = () =>
            postData = "project_id=" + $.openfire.page_vars.project_id
            postDict = {}
            for field in @updateFields
                if field in @richContentFields
                    val = encodeURIComponent($('#project-update-' + field + '-input').redactor().getCode())
                    postData += "&" + field + "=" + val
                    postDict[field] = val
                else if field in @booleanFields
                    val = ($('#project-update-' + field + '-input').attr('checked') == 'checked' ? 'true' : 'false')
                    postData += "&" + field + "=" + val
                    postDict[field] = val
                else
                    val = $('#project-update-' + field + '-input').val()
                    postData += "&" + field + "=" + val
                    postDict[field] = val

            $.ajax
                type: 'POST',
                url: '/_api/v1/project_update/',
                data: postData,
                success: (response) =>
                    for field in @updateFields
                        if field in @richContentFields
                            $('#project-update-' + response + '-' + field).html(decodeURIComponent(postDict[field]))
                        else if field != 'id'
                            $('#project-update-' + response + '-' + field).html(postDict[field])
                        else if field in @booleanFields
                            if postDict[field]
                                $('#project-update-' + response + '-' + field).html('true')
                            else
                                $('#project-update-' + response + '-' + field).html('true')
                    #$('#project-update-' + response + '-id').html(response)
                    @updateEditorDlg.modal('hide')
                error: (response) =>
                    alert('Error! ' + response.responseText)

        @saveUpdateComment = (id, content) =>
            postData = "id=" + id + "&content=" + encodeURIComponent(content)
            $.ajax
                type: 'POST',
                url: '/_api/v1/project_update_comment/',
                data: postData,
                success: (response) =>
                    # Add the new comment to the list on the page.
                    list = $('#update-comment-list-' + id)
                    el = list.find('.update-comment-template').clone()
                            .removeClass('update-comment-template')
                            .appendTo(list).show()
                    el.find('.update-comment-content').html(content)
                    el.find('.update-comment-author').html('you')
                    el.find('.update-comment-created').html('just now')
                    list.find('.no-comments-item').hide()
                    $('#project-update-inline-' + id).hide()

                error: (response) =>
                    alert('Error saving comment! ' + response.responseText)



window.ProjectUpdatesPageController = ProjectUpdatesPageController
$.openfire.controller_classes.project_updates_page = ProjectUpdatesPageController
