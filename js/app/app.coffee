$ ->
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

    items = new Items

    class ItemView extends Backbone.View
        tagName: "li"
        className: "item list_view"
        template: _.template '''<div class="content"><%= content %></div>
                                <div class="amount"><%= amount %></div>
                                <div class="date"><%= year %>-<%= month %>-<%= date %></div>
                                <div class="actions">
                                    <a href="#" class="remove">
                                        <img src="images/destroy.png" alt="remove" title="remove" />
                                    </a>
                                </div>'''
        
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
            'click .remove': 'delete'

    class InputView extends Backbone.View
        el: $ '#input_view'
        content: $ 'input#content'
        amount: $ 'input#amount'

        initialize: ->
            _.bindAll @

        render: ->
            @

        submit_create: (e)->
            e.preventDefault()
            if @content.val() and @amount.val()
                items.create content: @content.val(), amount: @amount.val()
                @content.val ''
                @amount.val ''
            false

        events:
            'submit #input_form': 'submit_create'

    inputView = new InputView

    class StatsView extends Backbone.View
        el: $ '#stats_view'
        count: $ '#count'
        avg: $ '#avg'
        sum: $ '#sum'

        initialize: ->
            _.bindAll @
            items.bind 'all', @render, @

        render: ->
            @count.html items.length
            @avg.html items.length
            @sum.html items.length

    statsView = new StatsView

    class ItemsView extends Backbone.View
        el: $ '#items_view'

        initialize: ->
            _.bindAll @
            items.bind 'add', @onAdd, @
            items.bind 'fetch', @onFetch, @

            items.fetch add:true

        onFetch: -> # no use for now
            items.each @onAdd

        render: ->
            @

        onAdd: (item) ->
            view = new ItemView model: item
            $('#item_list').append(view.render().el).fadeIn()
            
    itemsView = new ItemsView