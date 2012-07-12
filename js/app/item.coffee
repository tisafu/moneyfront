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
        if not @content
            @content = @defaults.content
        if not create_time
            @create_time = @defaults.create_time

    clear: ->
        @destroy()