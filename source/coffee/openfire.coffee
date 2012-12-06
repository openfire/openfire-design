# Base js for openfire.

# Set up some global variables.
$.openfire = {}
$.openfire.page_vars = {}
$.openfire.controller_classes = {}
$.openfire.controllers = {}
$.openfire.models = {}
$.openfire.views = {}
$.openfire.collections = {}

$.openfire.api = (method, name, data, success, error) ->
    $.ajax
        type: method
        url: '/_api/v1/' + name + '/'
        data: data
        dataType: 'json'
        contentType: 'application/json'
        success: success
        error: error

$(document).ready () ->

    # Initialize any controllers that have been registered.
    for name, cls of $.openfire.controller_classes
        $.openfire.controllers[name] = new cls()
        $.openfire.controllers[name].init()



class OFBaseView extends Backbone.View

    formChanged: (event) ->
        target = $(event.currentTarget)
        @setValue(target.attr('name'), target.val())

    # Override this to use formChanged
    setValue: (key, val) ->
window.OFBaseView = OFBaseView
