class HomeView extends Backbone.View
    initialize: ->
        @input = @$('new_content')
        items.bind 'add', @addOne, @
        items.fetch()

    render: ->
        alert "herew1"
        @

    addOne: (new_item) ->
        alert "here"
        view = new ItemView
            model: new_item
        @$('#items').append view.render().el

    createOnEnter: (e) ->
        if e.keyCode not 13
            return
        if not this.input.val()
            return
        items.create
            content: @input.val()


window.App = new HomeView()