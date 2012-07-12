class ItemView extends Backbone.View
    tagName: "li"
    className: "item"
    
    initialize: ->
        @model.bind 'change', @render, @
        @model.bind 'destroy', @remove, @

    render: ->
        @model.toJSON()

    clear: ->
        @model.clear()