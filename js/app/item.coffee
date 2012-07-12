class Item extends Backbone.Model
    defaults: ->
        content: "content"
        year: (new Date()).getFullYear()
        month: (new Date()).getMonth()+1
        date: (new Date()).getDate()
        amount: 0.0
        tags: []
        create_time: $.now()

    initialize: ->
        if not @.get "content"
            @.set "content", @defaults.content
        if not @.get "create_time"
            @.set "create_time", @defaults.create_time

    clear: ->
        @destroy()