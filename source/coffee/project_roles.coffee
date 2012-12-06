## openfire project page role management.


class ProjectRoleInvite extends Backbone.Model
    url: '/_api/v1/project_role_invite/'
    defaults:
        to_user: 0
        from_user: 0
        project: 0
        role: ''
        custom: ''
        created: ''
        message: ''
        status: 's'

    initialize: ->

class ProjectRoleInviteAction extends Backbone.Model
    url: '/_api/v1/project_role_invite_action/'
    defaults:
        status: 's'
    initialize: ->


class ProjectRoleInviteCollection extends Backbone.Collection
    model: ProjectRoleInvite


class ProjectRoleInviteView extends OFBaseView

    initialize: ->
        @newInvite = new ProjectRoleInvite
            project: $.openfire.page_vars.project_id
            from_user: $.openfire.page_vars.user_id

        @hiddenRows = ['a', 'c', 'd']
        [$(@el).find('.row-status-' + row).hide() for row in @hiddenRows]

        # TODO: This should be in a new ProjectRoleView some time soon.
        $('.remove-team-member-btn').click(@removeTeamMember)

    el: $('#project-role-invites')

    events:
        'click #save-project-role-invite-btn': 'saveNewInvite'
        'click .accept-invite-btn': 'acceptInvite'
        'click .decline-invite-btn': 'declineInvite'
        'click .cancel-invite-btn': 'cancelInvite'
        'change #project-role-invite-role': 'customRoleToggle'
        'change input': 'formChanged'
        'change select': 'formChanged'
        'change #show-all-role-invites': 'toggleAllRoleInvites'

    render: ->
        alert('role invite render')

    idForAction: (attr) ->
        return attr.match(/project-role-invite-(\d+)/)[1]

    takeInviteAction: (id, status, result, target) ->
        response = new ProjectRoleInviteAction(id: parseInt(id), status: status)
        response.url += id + '/'
        response.save()
        target.parents('tr').find('.role-invite-status').html(status)
        target.parents('tr').find('.role-invite-status-display').html(result)

    acceptInvite: (event) ->
        target = $(event.currentTarget)
        id = @idForAction(target.parents('tr').attr('id'))
        @takeInviteAction(id, 'a', 'Accepted', target)

    declineInvite: (event) ->
        target = $(event.currentTarget)
        id = @idForAction(target.parents('tr').attr('id'))
        @takeInviteAction(id, 'd', 'Declined', target)

    cancelInvite: (event) ->
        target = $(event.currentTarget)
        id = @idForAction(target.parents('tr').attr('id'))
        @takeInviteAction(id, 'c', 'Canceled', target)

    setValue: (key, val) ->
        @newInvite.set(key, val)

    saveNewInvite: ->
        # Must gather the rich text fields before save.
        @newInvite.set('message', $('#project-role-invite-message').redactor().getCode())
        result = @newInvite.save()
        alert('Saved! (refresh page)')
        $('#role-invite-dlg').modal('hide')

    customRoleToggle: ->
        if $('#project-role-invite-role').val() == 'c'
            $('#project-role-set-custom').show()
        else
            $('#project-role-invite-custom').val('')
            $('#project-role-set-custom').hide()

    toggleAllRoleInvites: (event) ->
        target = $(event.currentTarget)
        if target.attr('checked')
            $(@el).find('tr').show()
        else
            [$(@el).find('.row-status-' + row).hide() for row in @hiddenRows]

    removeTeamMember: (event) ->
        target = $(event.currentTarget)
        id = target.attr('id').match(/remove-project-role-(\d+)/)[1]
        $.openfire.api 'POST', 'delete_project_role', 'id=' + id,
            (response) ->  # success
                $('#project-teammate-' + id).remove()
                alert('Removed.')
            (response) ->  # error
                alert('Error: ' + response.responseText)


class ProjectRolesPageController

    constructor: () ->

        @roleInviteDlg = null
        @roleRequestDlg = null

        @init = () =>
            $.openfire.views.role_invite_list = new ProjectRoleInviteView()
            @initDialogs()

        @initDialogs = () =>

window.ProjectRolesPageController = ProjectRolesPageController
$.openfire.controller_classes.project_roles_page = ProjectRolesPageController
