
# openfire header scripts.

class HeaderController

    constructor: () ->

        @init = () =>
            $('#my-project-select').change () ->
                url = $(this).val()
                if url
                    window.location = url


window.HeaderController = HeaderController
$.openfire.controller_classes.header = HeaderController
