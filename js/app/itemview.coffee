class ItemView extends Backbone.View
    tagName: "li"
    className: "item"
    template: _.template '<div class="item">'+
        '<div class="content"></div>'+
        '<div class="amount"></div>'+
        '<div class="date"></div>'+
        '</div>'
    
    initialize: ->
        @model.bind 'change', @render, @
        @model.bind 'destroy', @remove, @

    render: ->
        @.$el.html @template @model.toJSON()
        @

    clear: ->
        @model.clear()