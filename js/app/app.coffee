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
        comparator: (item) ->
            item.get 'create_time'

    items = new Items

    class ItemView extends Backbone.View
        tagName: "li"
        className: "item list_view"
        template: _.template '''<div class="content cell"><%= content %></div>
                                <div class="amount cell"><%= amount %></div>
                                <div class="date cell"><%= year %>-<%= month %>-<%= date %></div>
                                <div class="actions cell">
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
            $(@el).slideUp 'fast', ->
                $(@el).remove

        delete: ->
            @model.destroy()

        edit: ->
            content = @$('.content')
            original_val = content.text()
            content.empty().append $('<input type="text" id="editing"></input>').val(original_val)
            @$('#editing').focus()

        editFinish: ->
            new_val = @$('#editing').val()
            if new_val.length? and new_val.length > 0
                @model.set 'content', new_val
                @model.save()
            else
                @$('#editing').focus()

        events:
            'click .remove': 'delete'
            'dblclick .content': 'edit'
            'focusout #editing': 'editFinish'

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
            content = $.trim @content.val()
            amount = parseFloat @amount.val()

            if content? and content and amount? and _.isNumber(amount) and not _.isNaN(amount)
                items.create content: content, amount: Math.round(amount * 100) / 100
                @content.val ''
                @amount.val ''
            false

        events:
            'submit #input_form': 'submit_create'

    inputView = new InputView

    class StatsView extends Backbone.View
        el: $ '#stats_view'
        count_tag: $ '#count'
        avg_tag: $ '#avg'
        sum_tag: $ '#sum'

        initialize: ->
            _.bindAll @
            items.bind 'all', @render, @ # always re-render

        render: ->
            @count_tag.html items.length
            if items.length
                sum = _.reduce items.pluck('amount'), (s, n) -> s + n
                @avg_tag.html Math.round(sum / items.length * 100) / 100
            else
                sum = 0.0
                @avg_tag.html 'n/a'
            @sum_tag.html sum

    statsView = new StatsView

    class ItemsView extends Backbone.View
        el: $ '#items_view'
        header: $ '#head'
        list: $ '#item_list'

        initialize: ->
            _.bindAll @
            items.bind 'add', @onAdd, @
            items.bind 'remove', @onRemove, @
            items.bind 'reset', @render, @
            items.fetch()

        render: ->
            if items.length > 0
                @header.show()
            else
                @header.hide()
            items.each (item) => #!!!carefull!! -> instead of => cause this to be un-bound
                view = new ItemView model: item
                @list.append view.render().el
            @

        onAdd: (item) ->
            @header.fadeIn() # if the header is not shown, show it first
            view = new ItemView model: item
            $(view.render().el).hide().appendTo(@list).slideDown()

        onRemove: (item) ->
            if items.length == 0
                @header.fadeOut()

        sortByContent: ->
            items.comparator = (item) ->
                item.get 'content'
            items.sort()

        events:
            'click #head-content': 'sortByContent'

    itemsView = new ItemsView