jQuery ->
    class Item extends Backbone.Model
        defaults:
            content: "content"
            year: (new Date()).getFullYear()
            month: (new Date()).getMonth()+1
            date: (new Date()).getDate()
            amount: 0.0
            tags: []
            create_time: $.now()

    class Items extends Backbone.Collection
        model: Item
        localStorage: new Backbone.LocalStorage "items-backstore"

    class ItemView extends Backbone.View
        tagName: "div"
        className: "item"
        template: _.template '<span class="content inline"><%= content %></span>'+
            '<span class="amount inline"><%= amount %></span>'+
            '<span class="date inline"><%= year %>-<%= month %>-<%= date %></span>'+
            '<button class="remove">删除</button>'
        
        initialize: ->
            _.bindAll @
            @model.bind 'change', @render, @
            @model.bind 'destroy', @unrender, @

        render: ->
            $(@el).html @template @model.toJSON()
            @

        unrender: ->
            $(@el).remove()

        delete: ->
            @model.destroy()

        events:
            'click button.remove': 'delete'

    class HomeView extends Backbone.View
        el: $ '#main'

        initialize: ->
            _.bindAll @
            @items = new Items
            @items.bind 'add', @onAdd, @
            @items.bind 'all', @render, @
            @items.bind 'fetch', @onFetch, @

            @items.fetch add:true

        onFetch: ->
            @items.each @onAdd

        render: ->
            $('#stats').empty().append @items.length
            @

        onAdd: (item) ->
            view = new ItemView model: item
            $('#items').append view.render().el

        createItem: ->
            if not $('input').val()
                return
            @items.create content: $('input').val()
            $('input').val ''

        events:
            'click button': 'createItem'
            
    app = new HomeView