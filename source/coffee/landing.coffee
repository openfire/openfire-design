
class LandingView extends OFBaseView

    el: $('#main-container')
    projectCards: $('#project-cards')
    filters: $('#project-filter-list')
    filterBtns: {show: $('#show-project-filters'), hide: $('#hide-project-filters')}

    initialize: ->
        # Set the width of the project card container.
        numCards = $('.project-card').length
        cardWidth = parseInt($('.project-card').css('width')) + 30
        @projectCards.css(width: cardWidth * numCards)

        $('#hd-sub-text').fitText(1.9, { minFontSize: '10px', maxFontSize: '18px' })

        """
        # Can't get iscroll to work yet.
        document.getElementById('project-cards').addEventListener 'touchmove', (e) ->
            e.preventDefault()
        @cardScroll = new iScroll 'project-cards',
            hScrollbar: false
        """

    events:
        'click #show-project-filters': 'showFilters'
        'click #hide-project-filters': 'hideFilters'

    showFilters: (event) =>
        @filterBtns.show.hide()
        @filterBtns.hide.show()
        @filters.animate height: '200px', =>
            @filters.css(overflow: 'auto')

    hideFilters: (event) =>
        @filterBtns.show.show()
        @filterBtns.hide.hide()
        @filters.css(overflow: 'hidden')
        @filters.animate height: '0px'



class LandingPageController

    constructor: () ->

        @init = () =>
            graph = $('#project-graph')
            if graph and graph.length
                $.openfire.activity_graphs = new $.openfire.activity_graph_controller()

            $.openfire.views.landing_view = new LandingView()



window.LandingPageController = LandingPageController
$.openfire.controller_classes.landing_page = LandingPageController
