## openfire propose page.

# TODO: Shoud be using the proposal object instead.
PROPOSAL_PROP_LIST = ['name', 'desired_url', 'summary', 'category', 'pitch', 'tech', 'team_description']
INITIAL_GOAL_PROP_LIST = ['goal_amount', 'goal_summary', 'goal_description', 'funding_day_limit', 'deliverable_date']
FUTURE_GOAL_PROP_LIST = ['future_goal_summary', 'future_goal_description']

INT_PROP_LIST = ['funding_day_limit']
FLOAT_PROP_LIST = ['goal_amount']
DATE_PROP_LIST = ['deliverable_date']
SELECT_PROP_LIST = ['category']


class ProposePageController

    constructor: () ->

        @init = () =>

            @initValidators()
            @initProposalStarterIdeas()

            onWizardNext = (tab, navigation, index)  =>
                if index == 1
                    return $('#proposal-step-1-frm').valid()
                if index == 2
                    return $('#proposal-step-2-frm').valid()
                if index == 3
                    return $('#proposal-step-3-frm').valid()
                return true

            onWizardTabClick = (tab, navication, index, e) =>
                target = parseInt($(e.target).attr('href').substr('#step-'.length))
                if target == 2
                    return $('#proposal-step-1-frm').valid()
                if target == 3
                    return ($('#proposal-step-1-frm').valid() and $('#proposal-step-2-frm').valid())
                if target == 4
                    return ($('#proposal-step-1-frm').valid() and $('#proposal-step-2-frm').valid() and $('#proposal-step-3-frm').valid())
                return true

            onShowStepCb = (tab, navigation, index) =>
                if index == 3
                    @collectProposeForm()
                    $('#propose-wizard .nav-btn-finish').removeClass('disabled').show()
                    $('#propose-wizard .nav-btn-next').hide()
                else
                    $('#propose-wizard .nav-btn-finish').hide()
                    $('#propose-wizard .nav-btn-next').show()

                if index == 1
                    $('#proposal-initial-goal-deliverable_date').datepicker(format: 'mm-dd-yyyy')

                return true

            onFinishCb = () =>
                @collectProposeForm()
                @createProposal()

            wizard = $('#propose-wizard')
            if wizard and wizard.length
                $('#propose-wizard').bootstrapWizard
                    onNext: onWizardNext
                    onTabShow: onShowStepCb
                    onTabClick: onWizardTabClick
                $('#propose-wizard .finish').click(onFinishCb)

    initValidators: () =>
        $('form.validate').each (num, frm) ->
            $(frm).validate
                debug:true
                errorPlacement: (error, element) ->
                    error.appendTo(element.parent().find('.error'))

    convertProp: (name, val) =>
        try
            if name in INT_PROP_LIST
                return parseInt(val)
            else if name in FLOAT_PROP_LIST
                return parseFloat(val)
            else if name in DATE_PROP_LIST
                date = new Date(val)
                return date.toISOString()
        catch err
            console.log('Failed to decode value.')
        return val

    collectProposeForm: () =>

        for prop in PROPOSAL_PROP_LIST
            propContent = $("#proposal-" + prop).val()
            $("#" + prop + "-summary").html(propContent)
            if prop in SELECT_PROP_LIST
                propDisplay = $("#proposal-" + prop + " option:selected").html()
                $("#" + prop + "-summary-display").html(propDisplay)
        for prop in INITIAL_GOAL_PROP_LIST
            propContent = $("#proposal-initial-goal-" + prop).val()
            $("#initial-goal-" + prop + "-summary").html(propContent)
        for prop in FUTURE_GOAL_PROP_LIST
            propContent = $("#proposal-future-goal-" + prop).val()
            $("#future-goal-" + prop + "-summary").html(propContent)


    buildProposalParams: () =>

        @collectProposeForm()
        proposalParams = {}
        for prop in PROPOSAL_PROP_LIST
            propContent = $("#" + prop + '-summary').html()
            propContent = @convertProp(prop, propContent)
            proposalParams[prop] = propContent

        initialGoalParams = {}
        for prop in INITIAL_GOAL_PROP_LIST
            propContent = $("#initial-goal-" + prop + '-summary').html()
            propContent = @convertProp(prop, propContent)
            proposalParams[prop] = propContent

        futureGoalParams = {}
        for prop in FUTURE_GOAL_PROP_LIST
            propContent = $("#future-goal-" + prop + '-summary').html()
            propContent = @convertProp(prop, propContent)
            proposalParams[prop] = propContent

        return proposalParams


    redirectToProposalPage: (key) =>
        window.setTimeout (() ->
            location.href = '/proposal/' + key
            ), 3000

    createProposal: () =>
        proposalParams = @buildProposalParams()
        $.openfire.api 'POST', 'create_proposal', proposalParams,
            (response) => # success
                $.openfire.wizards.showAlert 'propose-wizard', 'success',
                    'Your proposal has been created! You will be redirected to your new proposal page in 3 seconds...'
                @redirectToProposalPage(response)

            (response) => # error
                if response.status == 200
                    $.openfire.wizards.showAlert 'propose-wizard', 'success',
                        'Your proposal has been created! You will be redirected to your new proposal page in 3 seconds...'
                    @redirectToProposalPage(response.responseText)
                else
                    $.openfire.wizards.showAlert 'propose-wizard', 'error',
                        'There was an error: ' + response.responseText

    initProposalStarterIdeas: () ->
        $('#populate-proposal-starter-btn').click () ->
            ideaID = $('#proposal-starter-select').val()
            if not OPENFIRE_STARTER_PROJECTS[ideaID]
                $.simple_alert.alert('Choose a valid proposal starter')
                return
            idea = OPENFIRE_STARTER_PROJECTS[ideaID]
            $('#proposal-name').val(unescape(idea.name))
            $('#proposal-desired_url').val(idea.url)
            $('#proposal-category').val(idea.category)
            $('#proposal-summary').val(unescape(idea.summary))
            $('#proposal-pitch').val(unescape(idea.pitch))
            $('#proposal-initial-goal-goal_amount').val(idea.goal_amount)
            $('#proposal-initial-goal-funding_day_limit').val(idea.funding_day_limit)
            $('#proposal-initial-goal-deliverable_date').val(idea.deliverable_date)
            $('#proposal-initial-goal-goal_summary').val(unescape(idea.initial_goal_summary))
            $('#proposal-initial-goal-goal_description').val(unescape(idea.initial_goal_description))
            $('#proposal-future-goal-future_goal_summary').val(unescape(idea.future_goal_summary))
            $('#proposal-future-goal-future_goal_description').val(unescape(idea.future_initial_goal_description))
            $('#proposal-tech').val(unescape(idea.tech))
            $('#proposal-team_description').val(unescape(idea.team))
            $('#proposal-wizard-dialog').modal('show')


window.ProposePageController = ProposePageController
$.openfire.controller_classes.proposal_page = ProposePageController
