
# openfire content display and editing.

class ContentController

    constructor: () ->

        @editDlg = null
        @editor = null
        @editTmpl = null
        @calledFrom = null
        @newContent = null
        @canEdit = null

        @init = () =>
            @canEdit = $.openfire.page_vars.can_edit
            if @canEdit
                @initContentEditor()

        @initContentEditor = () =>
            @editDlg = $('#content-editor-dlg')
            if @editDlg and @editDlg.length
                @editDlg.modal
                    show: false

                @editTmpl = $('#edit-action-tmpl .edit-action')
                @editor = $('#content-editor-textarea')

                $('.of-editable').each () ->
                    _this.initEditable($(this))

                $('#content-editor-save-btn').click(@saveContent)
                $('#content-editor-cancel-btn').click(@closeContentEditor)

        @initEditable = (obj) =>
            action = @editTmpl.clone()
            action.insertBefore(obj)
                .click () =>
                    @startEditContent(obj)

        @startEditContent = (obj) =>
            opts = {}
            if obj.hasClass('text-only')
                opts.toolbar = false
            @editor.redactor(opts)
            @editor.setCode(obj.html())
            @calledFrom = obj
            @editDlg.modal('show')

        @closeContentEditor = () =>
            @editor.redactor().destroyEditor()
            @editDlg.modal('hide')

        @saveContent = () =>
            url = ''
            field = ''
            data = {}
            method = 'PUT'
            if @calledFrom.hasClass('project-content')
                url = '/_api/v1/project/' + $.openfire.page_vars.project_id + '/'
                field = @calledFrom.attr('id').match(/project-field-(\w+)/)[1]
                data.id = $.openfire.page_vars.project_id

            if @calledFrom.hasClass('profile-content')
                url = '/_api/v1/user_profile/' + $.openfire.page_vars.profile_id + '/'
                field = @calledFrom.attr('id').match(/profile-field-(\w+)/)[1]
                data.id = $.openfire.page_vars.profile_id

            if @calledFrom.hasClass('bbq-content')
                url = '/_api/v1/bbq_content/'
                data = 'name=' + @calledFrom.attr('id').match(/bbq-field-(\w+)/)[1]
                data += '&content='
                method = 'POST'

            if @calledFrom.hasClass('text-only')
                @newContent = $.trim(@editor.redactor().getText())
            else
                @newContent = @editor.redactor().getCode()


            if method == 'PUT'
                data[field] = @newContent
                $.ajax
                    type: method
                    url: url
                    data: JSON.stringify(data)
                    dataType: 'json'
                    contentType: 'application/json'
                    success: @contentSaved
                    error: @contentSaveError
            else
                data += @newContent
                $.ajax
                    type: method
                    url: url
                    data: data
                    success: @contentSaved
                    error: @contentSaveError


        @contentSaved = (response) =>
            @editDlg.modal('hide')
            $.simple_alert.alert('New content saved!')
            @calledFrom.html(@newContent)
            @closeContentEditor()

        @contentSaveError = (response) =>
            if response.status == 401
                alert('Unauthorized. Are you logged in?')
            alert('Error: ' + response.statusText + ': ' + response.responseText)



window.ContentController = ContentController
$.openfire.controller_classes.content = ContentController
