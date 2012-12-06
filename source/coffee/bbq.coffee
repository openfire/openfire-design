## openfire bbq page.


class BBQPageController

    constructor: () ->

        @init = () =>
            $('.bbq-datatable').dataTable()


window.BBQPageController = BBQPageController
$.openfire.controller_classes.bbq_page = BBQPageController
