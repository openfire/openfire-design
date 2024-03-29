// Generated by CoffeeScript 1.3.3
(function() {
  var OFBaseView,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $.openfire = {};

  $.openfire.page_vars = {};

  $.openfire.controller_classes = {};

  $.openfire.controllers = {};

  $.openfire.models = {};

  $.openfire.views = {};

  $.openfire.collections = {};

  $.openfire.api = function(method, name, data, success, error) {
    return $.ajax({
      type: method,
      url: '/_api/v1/' + name + '/',
      data: data,
      dataType: 'json',
      contentType: 'application/json',
      success: success,
      error: error
    });
  };

  $(document).ready(function() {
    var cls, name, _ref, _results;
    _ref = $.openfire.controller_classes;
    _results = [];
    for (name in _ref) {
      cls = _ref[name];
      $.openfire.controllers[name] = new cls();
      _results.push($.openfire.controllers[name].init());
    }
    return _results;
  });

  OFBaseView = (function(_super) {

    __extends(OFBaseView, _super);

    function OFBaseView() {
      return OFBaseView.__super__.constructor.apply(this, arguments);
    }

    OFBaseView.prototype.formChanged = function(event) {
      var target;
      target = $(event.currentTarget);
      return this.setValue(target.attr('name'), target.val());
    };

    OFBaseView.prototype.setValue = function(key, val) {};

    return OFBaseView;

  })(Backbone.View);

  window.OFBaseView = OFBaseView;

}).call(this);
