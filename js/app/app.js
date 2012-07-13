// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $(function() {
    var InputView, Item, ItemView, Items, ItemsView, StatsView, inputView, items, itemsView, statsView;
    Item = (function(_super) {

      __extends(Item, _super);

      function Item() {
        return Item.__super__.constructor.apply(this, arguments);
      }

      Item.prototype.defaults = {
        content: "content",
        year: (new Date()).getFullYear(),
        month: (new Date()).getMonth() + 1,
        date: (new Date()).getDate(),
        amount: 0.0,
        tags: [],
        create_time: $.now()
      };

      return Item;

    })(Backbone.Model);
    Items = (function(_super) {

      __extends(Items, _super);

      function Items() {
        return Items.__super__.constructor.apply(this, arguments);
      }

      Items.prototype.model = Item;

      Items.prototype.localStorage = new Backbone.LocalStorage("items-backstore");

      Items.prototype.comparator = function(item) {
        return item.get('create_time');
      };

      return Items;

    })(Backbone.Collection);
    items = new Items;
    ItemView = (function(_super) {

      __extends(ItemView, _super);

      function ItemView() {
        return ItemView.__super__.constructor.apply(this, arguments);
      }

      ItemView.prototype.tagName = "li";

      ItemView.prototype.className = "item list_view";

      ItemView.prototype.template = _.template('<div class="content cell"><%= content %></div>\n<div class="amount cell"><%= amount %></div>\n<div class="date cell"><%= year %>-<%= month %>-<%= date %></div>\n<div class="actions cell">\n    <a href="#" class="remove">\n        <img src="images/destroy.png" alt="remove" title="remove" />\n    </a>\n</div>');

      ItemView.prototype.initialize = function() {
        _.bindAll(this);
        this.model.bind('change', this.render, this);
        return this.model.bind('destroy', this.unrender, this);
      };

      ItemView.prototype.render = function() {
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
      };

      ItemView.prototype.unrender = function() {
        return $(this.el).slideUp('fast', function() {
          return $(this.el).remove;
        });
      };

      ItemView.prototype["delete"] = function() {
        return this.model.destroy();
      };

      ItemView.prototype.edit = function() {
        var content, original_val;
        content = this.$('.content');
        original_val = content.text();
        content.empty().append($('<input type="text" id="editing"></input>').val(original_val));
        return this.$('#editing').focus();
      };

      ItemView.prototype.editFinish = function() {
        var new_val;
        new_val = this.$('#editing').val();
        if ((new_val.length != null) && new_val.length > 0) {
          this.model.set('content', new_val);
          return this.model.save();
        } else {
          return this.$('#editing').focus();
        }
      };

      ItemView.prototype.events = {
        'click .remove': 'delete',
        'dblclick .content': 'edit',
        'focusout #editing': 'editFinish'
      };

      return ItemView;

    })(Backbone.View);
    InputView = (function(_super) {

      __extends(InputView, _super);

      function InputView() {
        return InputView.__super__.constructor.apply(this, arguments);
      }

      InputView.prototype.el = $('#input_view');

      InputView.prototype.content = $('input#content');

      InputView.prototype.amount = $('input#amount');

      InputView.prototype.initialize = function() {
        return _.bindAll(this);
      };

      InputView.prototype.render = function() {
        return this;
      };

      InputView.prototype.submit_create = function(e) {
        var amount, content;
        e.preventDefault();
        content = $.trim(this.content.val());
        amount = parseFloat(this.amount.val());
        if ((content != null) && content && (amount != null) && _.isNumber(amount) && !_.isNaN(amount)) {
          items.create({
            content: content,
            amount: Math.round(amount * 100) / 100
          });
          this.content.val('');
          this.amount.val('');
        }
        return false;
      };

      InputView.prototype.events = {
        'submit #input_form': 'submit_create'
      };

      return InputView;

    })(Backbone.View);
    inputView = new InputView;
    StatsView = (function(_super) {

      __extends(StatsView, _super);

      function StatsView() {
        return StatsView.__super__.constructor.apply(this, arguments);
      }

      StatsView.prototype.el = $('#stats_view');

      StatsView.prototype.count_tag = $('#count');

      StatsView.prototype.avg_tag = $('#avg');

      StatsView.prototype.sum_tag = $('#sum');

      StatsView.prototype.initialize = function() {
        _.bindAll(this);
        return items.bind('all', this.render, this);
      };

      StatsView.prototype.render = function() {
        var sum;
        this.count_tag.html(items.length);
        if (items.length) {
          sum = _.reduce(items.pluck('amount'), function(s, n) {
            return s + n;
          });
          this.avg_tag.html(Math.round(sum / items.length * 100) / 100);
        } else {
          sum = 0.0;
          this.avg_tag.html('n/a');
        }
        return this.sum_tag.html(sum);
      };

      return StatsView;

    })(Backbone.View);
    statsView = new StatsView;
    ItemsView = (function(_super) {

      __extends(ItemsView, _super);

      function ItemsView() {
        return ItemsView.__super__.constructor.apply(this, arguments);
      }

      ItemsView.prototype.el = $('#items_view');

      ItemsView.prototype.header = $('#head');

      ItemsView.prototype.list = $('#item_list');

      ItemsView.prototype.initialize = function() {
        _.bindAll(this);
        items.bind('add', this.onAdd, this);
        items.bind('remove', this.onRemove, this);
        items.bind('reset', this.render, this);
        return items.fetch();
      };

      ItemsView.prototype.render = function() {
        var _this = this;
        if (items.length > 0) {
          this.header.show();
        } else {
          this.header.hide();
        }
        items.each(function(item) {
          var view;
          view = new ItemView({
            model: item
          });
          return _this.list.append(view.render().el);
        });
        return this;
      };

      ItemsView.prototype.onAdd = function(item) {
        var view;
        this.header.fadeIn();
        view = new ItemView({
          model: item
        });
        return $(view.render().el).hide().appendTo(this.list).slideDown();
      };

      ItemsView.prototype.onRemove = function(item) {
        if (items.length === 0) {
          return this.header.fadeOut();
        }
      };

      ItemsView.prototype.sortByContent = function() {
        items.comparator = function(item) {
          return item.get('content');
        };
        return items.sort();
      };

      ItemsView.prototype.events = {
        'click #head-content': 'sortByContent'
      };

      return ItemsView;

    })(Backbone.View);
    return itemsView = new ItemsView;
  });

}).call(this);
