## openfire project page.


class ProjectPageController

    constructor: () ->

        @futureGoalDlg = null
        @futureGoalFields = ['id', 'summary', 'description']
        @goalDlg = null
        @goalFields = ['id', 'project', 'summary', 'description', 'amount', 'funding_day_limit', 'deliverable_date']
        @tierDlg = null
        @tierFields = ['id', 'name', 'description', 'amount', 'next_step_votes', 'backer_limit', 'goal']
        @nextStepDlg = null
        @nextStepFields = ['id', 'summary', 'description', 'goal']
        @richContentFields = ['description']


        @init = () =>
            @initDlgAction()
            @initProjectActions()
            @initFollow()
            @initKeywords()
            @initProjectSidebar()

            $('.editor-field').redactor
                buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', 'deleted', '|', 'unorderedlist', 'orderedlist', 'outdent', 'indent', 'link', 'fontcolor', 'backcolor', '|', 'alignment', '|', 'horizontalrule']
            $('#start-project-avatar-filepicker').click(@startAvatarPicker)
            @initVideoChooserDialog()
            if $('#project-video') and $('#project-video').length
                $('#project-video').fitVids()
            $('#project-hd').fitText(1.2, { minFontSize: '20px', maxFontSize: '40px' })
            $('#project-sidebar-name').fitText(1.1, { minFontSize: '16px', maxFontSize: '32px' })
            $('#project-sidebar-progress-bar-text').fitText(1.3, { minFontSize: '10px', maxFontSize: '18px' })
            $('input.datepicker').datepicker(format: 'mm-dd-yyyy')

        @initProjectSidebar = () =>
            showMoreInfo = $('#current-goal-show-more-info-link')
            showLessInfo = $('#current-goal-show-less-info-link')
            moreInfoInline = $('.current-goal-more-info-inline')
            showMoreInfo.click () ->
                showMoreInfo.hide()
                showLessInfo.show()
                moreInfoInline.css('height': 'auto', 'max-height': '0px', 'overflow': 'auto')
                moreInfoInline.animate('max-height': '200px')
            showLessInfo.click () ->
                showMoreInfo.show()
                showLessInfo.hide()
                moreInfoInline.css('overflow': 'hidden')
                moreInfoInline.animate {'height': '0px'}, () ->
                    moreInfoInline.css('max-height': '0px')

        @initFollow = () =>
            $('#project-follow-btn').click () =>
                data = 'project=' + $.openfire.page_vars.project_id
                $.openfire.api 'POST', 'follow_project', data,
                    (response) => # success
                        $.simple_alert.alert('You are now following this project! You will recieve updates ' +
                            'when things happen. Configure your notification settings on your account page.')
                        $('#project-follow-btn').hide()
                        $('#project-unfollow-btn').show()
                    (error) => # error
                        $.simple_alert.alert(error.responseText)

            $('#project-unfollow-btn').click () =>
                $.simple_alert.confirm 'Are you sure you want to stop following this project?', (confirmed) ->
                    if confirmed
                        data = 'project=' + $.openfire.page_vars.project_id
                        $.openfire.api 'POST', 'unfollow_project', data,
                            (response) => # success
                                $.simple_alert.alert('You no longer follow this project.')
                                $('#project-follow-btn').show()
                                $('#project-unfollow-btn').hide()
                            (error) => # error
                                $.simple_alert.alert(error.responseText)

        @initKeywords = () =>
            $('#edit-keywords-btn').click(@openKeywordEdit)
            $('#cancel-keywords-btn').click(@closeKeywordEdit)
            $('#save-keywords-btn').click () =>
                data = 'keywords=' + $('#project-keywords').val() + '&project=' + $.openfire.page_vars.project_id
                $.openfire.api 'POST', 'project_keywords', data,
                    (response) => # success
                        @closeKeywordEdit()
                    (error) => # error
                        alert(error.responseText)


        @openKeywordEdit = () =>
            existing = $('#project-keywords').html()
            $('#project-keywords').replaceWith('<input id="project-keywords" value="' + existing + '" />')
            $('#edit-keywords-btn').hide()
            $('#save-keywords-btn').show()
            $('#cancel-keywords-btn').show()

        @closeKeywordEdit = () =>
            existing = $('#project-keywords').val()
            $('#project-keywords').replaceWith('<span id="project-keywords">' + existing + '</span>')
            $('#edit-keywords-btn').show()
            $('#save-keywords-btn').hide()
            $('#cancel-keywords-btn').hide()

        @startAvatarPicker = () =>
            filepicker.pick {}, @avatarUploaded, @avatarUploadError

        @avatarUploaded = (file) =>
            data =
                target: 'project'
                id: $.openfire.page_vars.project_id
                url: file.url
                name: file.filename
                mime: file.mimetype
                size: file.size
            $.openfire.api 'POST', 'set_avatar', data,
                (response) => # success
                    $('#project-avatar-content').html("<img src='" + response + "'>")
                (error) => # error
                    if error.status == 200
                        $('#project-avatar-content').html("<img src='" + error.responseText + "'>")
                    else
                        alert(error.responseText)

        @avatarUploadError = (error) =>
            alert(error)

        @initVideoChooserDialog = () =>
            dlg = $('#video-chooser-dlg').modal(show: false)
            $('#save-video-chooser-btn').click(@setProjectVideo)
            $('#close-video-chooser-btn').click () =>
                dlg.modal('hide')
            $('#choose-project-video-btn').click () =>
                dlg.modal('show')


        @setProjectVideo = () =>
            data = $('#video-chooser-dlg').find('form').serialize()
            data += '&id=' + $.openfire.page_vars.project_id
            $.openfire.api 'POST', 'set_project_video', data,
                (response) => # success
                    window.location.reload()
                (error) => # error
                    if error.status == 200
                        window.location.reload()
                    else
                        alert error.responseText

        @initDlgAction = () =>

            _this = @
            @futureGoalDlg = $('#future-goal-dlg').modal(show: false)
            $('#save-future-goal-btn').click(@saveFutureGoal)
            $('#close-future-goal-btn').click () =>
                @futureGoalDlg.modal('hide')
            $('#edit-future-goal').click(@editFutureGoal)

            @goalDlg = $('#goal-dlg').modal(show: false)
            $('#save-goal-btn').click(@saveGoal)
            $('#close-goal-btn').click () =>
                @goalDlg.modal('hide')

            $('#edit-current-goal').click(@editGoal)
            $('#propose-new-goal').click(@proposeGoal)
            $('.edit-pending-goal').click () ->
                goalId = this.id.match(/edit-pending-goal-(\w+)/)[1]
                _this.editPendingGoal(goalId)

            @tierDlg = $('#tier-dlg').modal(show: false)
            $('#save-tier-btn').click(@saveTier)
            $('#close-tier-btn').click () =>
                @tierDlg.modal('hide')

            $('.edit-tier').click () ->
                tierId = /edit-tier-(\w+)/.exec(this.id)[1]
                _this.editTier(tierId)
            $('#add-tier').click(@addTier)

            @deleteTierDlg = $('#delete-tier-dlg').modal(show: false)
            $('#delete-tier-delete-btn').click(@deleteTier)
            $('#close-delete-tier-btn').click () =>
                @deleteTierDlg.modal('hide')
            $('.delete-tier').click () ->
                tierId = /delete-tier-(\w+)/.exec(this.id)[1]
                _this.startDeleteTier(tierId)

            @nextStepDlg = $('#next-step-dlg').modal(show: false)
            $('#save-next-step-btn').click(@saveNextStep)
            $('#close-next-step-btn').click () =>
                @nextStepDlg.modal('hide')
            $('.edit-next-step').click () ->
                nsId = /edit-next-step-(\w+)/.exec(this.id)[1]
                _this.editNextStep(nsId)
            $('#add-next-step').click(@addNextStep)

            @deleteNextStepDlg = $('#delete-next-step-dlg').modal(show: false)
            $('#delete-next-step-delete-btn').click(@deleteNextStep)
            $('#close-delete-next-step-btn').click () =>
                @deleteNextStepDlg.modal('hide')
            $('.delete-next-step').click () ->
                nextStepId = /delete-next-step-(\w+)/.exec(this.id)[1]
                _this.startDeleteNextStep(nextStepId)

            @openGoalDlg = $('#open-goal-dlg').modal(show: false)
            $('#open-goal-now-btn').click(@openCurrentGoal)
            $('#cancel-open-goal-btn').click () =>
                @openGoalDlg.modal('hide')
            $('#open-current-goal').click(@startOpenGoal)

            @closeGoalDlg = $('#close-goal-dlg').modal(show:false)
            $('#close-goal-now-btn').click(@closeCurrentGoal)
            $('#cancel-close-goal-btn').click () =>
                @closeGoalDlg.modal('hide')
            $('#close-current-goal').click(@startCloseGoal)


        @initProjectActions = () =>
            _this = @
            $('.of-project-action').click () ->
                actionSlug = this.id.match(/project-action-([-\w]+)/)[1]
                _this.performProjectAction(actionSlug)
            $('.of-goal-action').click () ->
                actionInfo = this.id.match(/goal-action-([-\w]+)-(\d+)/)
                _this.performProjectAction(actionInfo[1], actionInfo[2])

            $('.toggle').click () ->
                $(this).parent().parent().find('.toggle-content').toggle()
                $(this).find('.ui-icon').toggleClass('ui-icon-triangle-1-s')
                $(this).find('.ui-icon').toggleClass('ui-icon-triangle-1-e')

            $('.toggle-admin').click () ->
                $(this).parent().parent().find('.toggle-admin-content').toggle()
                $(this).find('.ui-icon').toggleClass('ui-icon-triangle-1-s')
                $(this).find('.ui-icon').toggleClass('ui-icon-triangle-1-w')


        @performProjectAction = (actionSlug, extra) =>
            postData = 'action=' + actionSlug + '&id=' + $.openfire.page_vars.project_id
            if extra
                postData += '&extra=' + extra

            $.ajax
                type: 'POST',
                url: '/_api/v1/project_action/',
                data: postData,
                success: (response) ->
                    alert 'Action taken! Response:' + response
                    window.location.reload()

                error: (response) ->
                    alert 'There was an error: ' + response.responseText

        @editFutureGoal = () =>
            for field in @futureGoalFields
                if field in @richContentFields
                    $('#future-goal-' + field + '-input').redactor().setCode($('#future-goal-' + field).html())
                else
                    $('#future-goal-' + field + '-input').val($('#future-goal-' + field).html())
            @futureGoalDlg.modal('show')


        @saveFutureGoal= () =>
            postDict = {}
            for field in @futureGoalFields
                if field in @richContentFields
                    postDict[field] = $('#future-goal-' + field + '-input').redactor().getCode()
                else
                    postDict[field] = $('#future-goal-' + field + '-input').val()
            postData = JSON.stringify(postDict)

            $.openfire.api 'PUT', 'future_goal/' + postDict['id'], postData,
                (response) =>
                    for field in @futureGoalFields
                        if field != 'id'
                            $('#future-goal-' + field).html(postDict[field])
                    @futureGoalDlg.modal('hide')
                (response) =>
                    alert('Error! ' + response.responseText)


        @editGoal = () =>
            for field in @goalFields
                if field in @richContentFields
                    $('#goal-' + field.replace(/_/g, '-') + '-input').redactor().setCode($('#goal-' + field.replace(/_/g, '-')).html())
                else
                    $('#goal-' + field.replace(/_/g, '-') + '-input').val($('#goal-' + field.replace(/_/g, '-')).html())
            @goalDlg.modal('show')


        @proposeGoal = () =>
            for field in @goalFields
                if field in @richContentFields
                    $('#goal-' + field.replace(/_/g, '-') + '-input').redactor().setCode('')
                else
                    $('#goal-' + field.replace(/_/g, '-') + '-input').val('')
            $('#goal-project-input').val($.openfire.page_vars.project_id)
            @goalDlg.modal('show')


        @editPendingGoal = (id) =>
            for field in @goalFields
                val = $('#pending-goal-' + id + ' .goal-' + field.replace(/_/g, '-')).html()
                if field in @richContentFields
                    $('#goal-' + field.replace(/_/g, '-') + '-input').redactor().setCode(val)
                else
                    $('#goal-' + field.replace(/_/g, '-') + '-input').val(val)
            $('#goal-project-input').val($.openfire.page_vars.project_id)
            @goalDlg.modal('show')


        @saveGoal = () =>
            postDict = {}
            for field in @goalFields
                if field == 'id'
                    val = $('#goal-' + field.replace(/_/g, '-') + '-input').val()
                    if val.length
                        postDict[field] = val
                else if field in @richContentFields
                    postDict[field] = $('#goal-' + field.replace(/_/g, '-') + '-input').redactor().getCode()
                else
                    postDict[field] = $('#goal-' + field.replace(/_/g, '-') + '-input').val()
            postData = JSON.stringify(postDict)

            url = 'goal'
            method = 'POST'
            if 'id' in postDict
                url += '/' + postDict['id']
                method = 'PUT'
            $.openfire.api method, url, postData,
                (response) =>
                    for field in @goalFields
                        if field != 'id'
                            $('#goal-' + field.replace(/_/g, '-')).html(postDict[field])
                    @goalDlg.modal('hide')
                (response) =>
                    alert('Error! ' + response.responseText)


        @editTier = (tierId) =>
            for field in @tierFields
                if field in @richContentFields
                    $('#tier-' + field.replace(/_/g, '-') + '-input').redactor().setCode($('#tier-' + tierId).find('.tier-' + field.replace(/_/g, '-')).html())
                else
                    $('#tier-' + field.replace(/_/g, '-') + '-input').val($('#tier-' + tierId + ' .tier-' + field.replace(/_/g, '-')).html())
            @tierDlg.modal('show')


        @addTier = () =>
            $('#tier-dlg input').val('')
            $('#tier-goal-input').val($('#tier-goal').html())
            @tierDlg.modal('show')


        @saveTier = () =>
            postDict = {}
            for field in @tierFields
                if field != 'id'
                    if field in @richContentFields
                        postDict[field] = $('#tier-' + field.replace(/_/g, '-') + '-input').redactor().getCode()
                    else
                        postDict[field] = $('#tier-' + field.replace(/_/g, '-') + '-input').val()
                tierId = $('#tier-id-input').val()
                if tierId and tierId.length
                    postDict.id = tierId
            postData = JSON.stringify(postDict)

            apiUrl = 'tier'
            apiMethod = 'POST'
            if postDict.id? and postDict.id.length
                apiUrl += '/' + postDict.id
                apiMethod = 'PUT'
            $.openfire.api apiMethod, apiUrl, postData,
                (response) =>
                    for field in @tierFields
                        if field != 'id'
                            $('#tier-' + postDict['id'] + ' .tier-' + field.replace(/_/g, '-')).html(postDict[field])
                    @tierDlg.modal('hide')
                (response) =>
                    alert('Error! ' + response.responseText)


        @editNextStep = (nsId) =>
            for field in @nextStepFields
                if field in @richContentFields
                    $('#next-step-' + field.replace(/_/g, '-') + '-input').redactor().setCode($('#next-step-toggle-' + nsId + ' .next-step-' + field.replace(/_/g, '-')).html())
                else
                    $('#next-step-' + field.replace(/_/g, '-') + '-input').val($('#next-step-toggle-' + nsId + ' .next-step-' + field.replace(/_/g, '-')).html())
            @nextStepDlg.modal('show')


        @addNextStep = () =>
            $('#next-step-dlg input').val('')
            $('#next-step-goal-input').val($('#next-step-goal').html())
            @nextStepDlg.modal('show')


        @saveNextStep = () =>
            postDict = {}
            for field in @nextStepFields
                if field != 'id'
                    if field in @richContentFields
                        postDict[field] = $('#next-step-' + field.replace(/_/g, '-') + '-input').redactor().getCode()
                    else
                        postDict[field] = $('#next-step-' + field.replace(/_/g, '-') + '-input').val()
                nextStepId = $('#next-step-id-input').val()
                if nextStepId and nextStepId.length
                    postDict.id = nextStepId
            postData = JSON.stringify(postDict)

            apiUrl = 'next_step'
            apiMethod = 'POST'
            if postDict.id? and postDict.id.length
                apiUrl += '/' + postDict.id
                apiMethod = 'PUT'
            $.openfire.api apiMethod, apiUrl, postData,
                (response) =>
                    for field in @nextStepFields
                        if field != 'id'
                            $('#next-step-toggle-' + postDict['id'] + ' .next-step-' + field.replace(/_/g, '-')).html(postDict[field])
                    @nextStepDlg.modal('hide')
                (response) =>
                    alert('Error! ' + response.responseText)

        @startOpenGoal = () =>
            @openGoalDlg.modal('show')

        @openCurrentGoal = () =>
            @performProjectAction('open-current-project-goal')
            @openGoalDlg.modal('hide')

        @startCloseGoal = () =>
            @closeGoalDlg.modal('show')

        @closeCurrentGoal = () =>
            @performProjectAction('close-current-project-goal')
            @closeGoalDlg.modal('hide')

        @startDeleteTier = (tierId) =>
            @deleteTierDlg.find('.tier-id-input').val(tierId)
            @deleteTierDlg.modal('show')

        @deleteTier = () =>
            data =
                id: @deleteTierDlg.find('.tier-id-input').val()
            $.openfire.api 'DELETE', 'tier/' + data.id, JSON.stringify(data),
                (response) => # success
                    alert 'tier deleted'
                    @deleteTierDlg.modal('hide')
                (response) => # error
                    alert 'there was an error: ' + response.responseText

        @startDeleteNextStep = (nextStepId) =>
            @deleteNextStepDlg.find('.next-step-id-input').val(nextStepId)
            @deleteNextStepDlg.modal('show')

        @deleteNextStep = () =>
            data =
                id: @deleteNextStepDlg.find('.next-step-id-input').val()
            $.openfire.api 'DELETE', 'next_step/' + data.id, JSON.stringify(data),
                (response) => # success
                    alert 'next step deleted'
                    @deleteNextStepDlg.modal('hide')
                (response) => # error
                    alert 'there was an error: ' + response.responseText



window.ProjectPageController = ProjectPageController
$.openfire.controller_classes.project_page = ProjectPageController
