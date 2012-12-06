## Bootstrap site-wide defaults for openfire.

class OFBootstrapController

    constructor: () ->

    init: () =>
        @initTabs()
        @initDialogs()
        @initWizards()
        @initAlerts()
        @initDropdowns()

    initTabs: () ->
        tabs = $('.of-tablist li a')
        if tabs and tabs.length
            tabs.click (e) ->
                e.preventDefault()
                $(this).tab('show')

    initDialogs: () ->
        # Initalize any dialogs that exist.
        for dlg in $('.of-dialog')
            if not $.openfire.dialogs
                $.openfire.dialogs = {els: {}}
            @initDialog($(dlg))

    initDialog: (dlg) ->
        # 'X' close button.
        dlg.find('.close-dialog').click (e) ->
            e.preventDefault()
            dlg.modal('hide')
            return false

        # Wizard close alert button.
        dlg.find('.close-dialog-alert').click (e) ->
            e.preventDefault()
            $(this).parent().hide()
            dlg.find('.alerts').css('z-index', '-1')
            return false

        $.openfire.dialogs.els[dlg.attr('id')] = dlg

        $.openfire.dialogs.showAlert = (id, type, text) =>
            thisDlg = $.openfire.dialogs.els[id]
            alert = thisDlg.find('.alert-' + type + '-text')
            if text
                alert.html(text)
            thisDlg.find('.alerts').css('z-index', '9999')
            alert.parent().show()

    initWizards: () ->
        # Initalize any wizards that exist.
        for wizard in $('.of-wizard')
            if not $.openfire.wizards
                $.openfire.wizards = {els: {}}
            @initWizard($(wizard))

    initWizard: (wizard) ->
        # Wizard close button.
        wizard.find('.close-wizard').click (e) ->
            e.preventDefault()
            wizard.parents('.of-wizard-modal').modal('hide')
            return false

        # Wizard close alert button.
        wizard.find('.close-wizard-alert').click (e) ->
            e.preventDefault()
            $(this).parent().hide()
            wizard.find('.alerts').css('z-index', '-1')
            return false

        $.openfire.wizards.els[wizard.attr('id')] = wizard

        $.openfire.wizards.showAlert = (id, type, text) =>
            wiz = $.openfire.wizards.els[id]
            alert = wiz.find('.alert-' + type + '-text')
            if text
                alert.html(text)
            wiz.find('.alerts').css('z-index', '9999')
            alert.parent().show()

    initAlerts: () ->
        # Provide a simple wrapper around bootbox for now.
        $.simple_alert =
            alert: bootbox.alert # str, label, cb
            confirm: bootbox.confirm # str, labelCancel, labelOk, cb
            prompt: bootbox.prompt # str, labelCancel, labelOk, cb, defaultVal

    initDropdowns: () ->
        # Bootstrap dropdowns don't work on mobile without this.
        $('.dropdown-menu').on('touchstart.dropdown.data-api', (e) ->
            e.stopPropagation() )

window.OFBootstrapController = OFBootstrapController
$.openfire.controller_classes.of_bootstrap = OFBootstrapController
