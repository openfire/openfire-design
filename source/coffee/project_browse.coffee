class ProjectCard extends Backbone.Model
    defaults: ->
        return {
            id: ''
            category: ''
            keywords: new Array()
        }

    show: =>
        $('#project-card-' + @.get('id')).show()

    hide: =>
        $('#project-card-' + @.get('id')).hide()

class ProjectCardCollection extends Backbone.Collection
    model: ProjectCard

    haveKeyword: (keyword) =>
        ret = new Array()
        for model in @models
            if keyword in model.get('keywords')
                ret.push(model)
        return ret

    haveKeywords: (keywords) =>
        ret = new Array()
        have = {}
        for keyword in keywords
            for proj in @haveKeyword(keyword)
                if not have[proj.get('id')]
                    ret.push(proj)
                    have[proj.get('id')] = true
        return ret

    filterCards: (categories, keywords) =>
        if keywords and keywords.length
            cards = @haveKeywords(keywords)
        else
            cards = @models

        if categories and categories.length
            filtered = new Array()
            for card in cards
                if card.get('category') in categories
                    filtered.push(card)
            cards = filtered

        return cards


class ProjectFilterView extends OFBaseView

    el: $('#project-filters')

    initialize: ->
        @cards = new ProjectCardCollection
        for card in $('.project-card')
            card = $(card)
            newCard = new ProjectCard()
            newCard.set('id', card.data('project'))
            newCard.set('category', card.data('category'))
            for keyword in card.data('keywords').split(' ')
                keywords= newCard.get('keywords')
                keywords.push(keyword)
                newCard.set('keywords', keywords)
            @cards.add(newCard)

    events:
        'change input': 'filterProjects'

    render: ->
        alert('filter projects render')

    filterProjects: (event) =>
        target = $(event.currentTarget)
        filterType = target.data('filter-type')
        if target.val() == '*'
            @selectAll(filterType)
            return

        categories = []
        for input in $('.category-filter input')
            if $(input).attr('checked')
                categories.push($(input).val())

        keywords = []
        for input in $('.keyword-filter input')
            if $(input).attr('checked')
                keywords.push($(input).val())

        allChecked = @allChecked(filterType)
        if allChecked
            $('.' + filterType + '-filters .select-all input').attr('checked', 'checked')
        else
            $('.' + filterType + '-filters .select-all input').removeAttr('checked')

        showCards = @cards.filterCards(categories, keywords)
        for card in @cards.models
            if card in showCards
                card.show()
            else
                card.hide()

    allChecked: (filterType) =>
        all = true
        boxes = $('.' + filterType + '-filter input')
        for box in boxes
            if not $(box).attr('checked')
                all = false
                break
        return all

    selectAll: (filterType) =>
        boxes = $('.' + filterType + '-filter input')
        if @allChecked(filterType)
            boxes.trigger('click')
        else
            for box in boxes
                if not $(box).attr('checked')
                    $(box).trigger('click')

class ProjectBrowsePageController

    constructor: () ->

        @init = () =>
            $.openfire.views.project_filter_view = new ProjectFilterView()

window.ProjectBrowsePageController = ProjectBrowsePageController
$.openfire.controller_classes.project_browse_page = ProjectBrowsePageController
