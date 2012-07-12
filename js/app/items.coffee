class Items extends Backbone.Collection
    model: Item
    localStorage: new Store("items-backstore")
    