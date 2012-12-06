
class ProfileView extends OFBaseView

    el: $('#profile-page-container')
    bioEl: $('#profile-field-bio')
    bioBtns: {show: $('#show-full-bio'), hide: $('#hide-full-bio')}

    initialize: ->

    events:
        'click #start-profile-avatar-filepicker': 'startAvatarChooser'
        'click #show-full-bio': 'showFullBio'
        'click #hide-full-bio': 'hideFullBio'

    startAvatarChooser: (event) =>
        filepicker.pick {}, @avatarUploaded, @avatarUploadError

    avatarUploaded: (file) =>
        data =
            target: 'profile'
            id: $.openfire.page_vars.profile_id
            url: file.url
            name: file.filename
            mime: file.mimetype
            size: file.size
        $.openfire.api 'POST', 'set_avatar', data,
            (response) => # success
                @setAvatarUrl(response)
            (error) => # error
                if error.status == 200
                    @setAvatarUrl(error.responseText)
                else
                    @avatarUploadError(error.responseText)

    avatarUploadError: (error) =>
        $.simple_alert.alert('Failed to update your profile avatar: ' + error)

    setAvatarUrl: (url) =>
        $('#profile-avatar-content').html("<img src='" + url + "'>")

    showFullBio: (event) =>
        @bioBtns.show.hide()
        @bioBtns.hide.show()
        @bioEl.animate {height: '500px'}, =>
            @bioEl.css(overflow: 'auto')

    hideFullBio: (event) =>
        @bioBtns.show.show()
        @bioBtns.hide.hide()
        @bioEl.css(overflow: 'hidden')
        @bioEl.animate height: '100px'



class ProfilePageController

    constructor: () ->

        @init = () =>
            $.openfire.views.profile_view = new ProfileView()

            # Set up the card container widths.
            cardWidth = parseInt($('.project-card').css('width')) + 30
            $('.profile-card-list').each (cardList) ->
                numCards = $(this).find('.project-card').length
                $(this).find('.card-list').css(width: cardWidth * numCards)


window.ProfilePageController = ProfilePageController
$.openfire.controller_classes.profile_page = ProfilePageController
