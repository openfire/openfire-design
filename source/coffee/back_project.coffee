
# openfire back project controller.

class BackProjectController

    constructor: () ->

        @dlg = null
        @wizard = null
        @project_id = null

        @init = () =>
            @dlg = $('#back-project-dlg')
            @wizard = $('#donate-wizard')
            if @dlg and @dlg.length
                @initDialog()

        @initDialog = () =>
            @dlg.modal(show: false)
            @project_id = $.openfire.page_vars.project_id

            if @wizard and @wizard.length
                @wizard.bootstrapWizard
                    onTabShow: @onShowStepCb
                @wizard.find('.finish').click(@submit)

            $('.vote-plus').click(@next_step_vote_plus)
            $('.vote-minus').click(@next_step_vote_minus)
            $('#donate-step-1 input[type="radio"]').click(@choose_donation_tier)
            $('#back-project-money-source-input').change(@select_money_source)

            $('#back-project-btn').click(@start)
            $('#populate-fake-cc-data').click(@populateFakeData)

        @start = () =>
            @dlg.modal('show')

        @onShowStepCb = (tab, navigation, index) =>
            if index == 2
                @dlg.find('.nav-btn-finish').removeClass('disabled').show()
                @dlg.find('.nav-btn-next').hide()
            else
                @dlg.find('.nav-btn-finish').hide()
                @dlg.find('.nav-btn-next').show()

        @choose_donation_tier = () ->
            # Set the number of next step votes.
            row = $(this).parents('.tier-info')
            $('#back-project .tier-selected').removeClass('tier-selected')
            row.addClass('tier-selected')
            $('#back-project-remaining-votes').val(row.find('.num-votes').html())
            $('.back-project-next-step-input').val(0)
            $('#back-project-amount-input').val(parseInt(row.find('.dollar-amount').html()))

        @next_step_vote_plus = () ->
            # Increment the nearest votes input and decrement the overall votes count.
            increment = $(this).parent().find('.back-project-next-step-input')
            decrement = $('#back-project-remaining-votes')

            remaining = parseInt(decrement.val())
            if remaining > 0
                increment.val(parseInt(increment.val()) + 1)
                decrement.val(remaining - 1)

        @next_step_vote_minus = () ->
            # Decrement the nearest votes input and increment the overall votes count.
            decrement = $(this).parent().find('.back-project-next-step-input')
            increment = $('#back-project-remaining-votes')

            remaining = parseInt(decrement.val())
            if remaining > 0
                increment.val(parseInt(increment.val()) + 1)
                decrement.val(remaining - 1)

        @select_money_source = () ->
            # If a previous money source was selected, clear and disable the new cc form.
            for el in $('#use-new-cc').find('input')
                if $(this).val()
                    $(el).val('')
                    el.disabled = true
                else
                    el.disabled = false

        @submit = () =>
            if @dlg.find('.nav-btn-finish').hasClass('disabled')
                return

            @dlg.find('.nav-btn-finish').addClass('disabled')

            # Simple way to submit a 'back project' request with a new credit card.
            votes = []
            for el in $('.back-project-next-step-input')
                votes.push
                    id: el.id.match(/next-step-(\w+)/)[1]
                    num_votes: parseInt($(el).val())

            tier = ''
            radios = $('input[name="tier"]')
            for radio in radios
                if radio.checked
                    tier = $(radio).val()
                    break

            params =
                user: $('#back-project-backer').val()
                project: @project_id
                tier: tier
                amount: $('#back-project-amount-input').val()
                next_step_votes: JSON.stringify votes
                money_source: $('#back-project-money-source-input').val()
                new_cc: JSON.stringify
                    cc_num: $('#back-project-cc-num-input').val()
                    ccv: $('#back-project-cc-ccv-input').val()
                    expire_month: $('#back-project-cc-month-input').val()
                    expire_year: $('#back-project-cc-year-input').val()
                    user_name: $('#back-project-cc-name-input').val()
                    email: $('#back-project-cc-email-input').val()
                    address1: $('#back-project-cc-address-1-input').val()
                    address2: $('#back-project-cc-address-2-input').val()
                    city: $('#back-project-cc-city-input').val()
                    state: $('#back-project-cc-state-input').val()
                    country: $('#back-project-cc-country-input').val()
                    zipcode: $('#back-project-cc-zipcode-input').val()
                    save_for_reuse: $('#back-project-cc-save-input').attr('checked')== 'checked'
            # Submit the back request via the payment.back_project service.
            $.ajax
                type: 'POST'
                url: '/_api/v1/back_project/'
                data: params
                success: (response) =>
                    $.openfire.wizards.showAlert('donate-wizard', 'success', null)
                error: (response) =>
                    @dlg.find('.nav-btn-finish').removeClass('disabled')
                    $.openfire.wizards.showAlert('donate-wizard', 'error', 'There was an error: ' + response.responseText)

        @detect_cc_type = () ->
            val = @.val()
            type = ''
            if /^4/.test(val)
                type = 'Visa'
            if /^(34|37)/.test(val)
                type = 'American Express'
            if /^5[1-5]/.test(val)
                type = 'MasterCard'
            if /^6011/.test(val)
                type = 'Discover'
            $('#back-project-cc-type-display').html(type)
            return false

        @populateFakeData = () ->
            $('#back-project-cc-num-input').val('4003830171874018')
            $('#back-project-cc-ccv-input').val('123')
            $('#back-project-cc-month-input').val('12')
            $('#back-project-cc-year-input').val('2015')
            $('#back-project-cc-name-input').val('Fakie McFakerton')
            $('#back-project-cc-email-input').val('Fakie@McFakerton.com')
            $('#back-project-cc-address-1-input').val('123 Fake St.')
            $('#back-project-cc-address-2-input').val()
            $('#back-project-cc-city-input').val('Las Vegas')
            $('#back-project-cc-state-input').val('NV')
            $('#back-project-cc-country-input').val('US')
            $('#back-project-cc-zipcode-input').val('89104')
            $('#back-project-cc-save-input').attr('checked', 'checked')


window.BackProjectController = BackProjectController
$.openfire.controller_classes.back_project = BackProjectController
