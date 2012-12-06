// Generated by CoffeeScript 1.3.3
(function() {
  var OFBootstrapController,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  OFBootstrapController = (function() {

    function OFBootstrapController() {
      this.init = __bind(this.init, this);

    }

    OFBootstrapController.prototype.init = function() {
      this.initTabs();
      this.initDialogs();
      this.initWizards();
      this.initAlerts();
      return this.initDropdowns();
    };

    OFBootstrapController.prototype.initTabs = function() {
      var tabs;
      tabs = $('.of-tablist li a');
      if (tabs && tabs.length) {
        return tabs.click(function(e) {
          e.preventDefault();
          return $(this).tab('show');
        });
      }
    };

    OFBootstrapController.prototype.initDialogs = function() {
      var dlg, _i, _len, _ref, _results;
      _ref = $('.of-dialog');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dlg = _ref[_i];
        if (!$.openfire.dialogs) {
          $.openfire.dialogs = {
            els: {}
          };
        }
        _results.push(this.initDialog($(dlg)));
      }
      return _results;
    };

    OFBootstrapController.prototype.initDialog = function(dlg) {
      var _this = this;
      dlg.find('.close-dialog').click(function(e) {
        e.preventDefault();
        dlg.modal('hide');
        return false;
      });
      dlg.find('.close-dialog-alert').click(function(e) {
        e.preventDefault();
        $(this).parent().hide();
        dlg.find('.alerts').css('z-index', '-1');
        return false;
      });
      $.openfire.dialogs.els[dlg.attr('id')] = dlg;
      return $.openfire.dialogs.showAlert = function(id, type, text) {
        var alert, thisDlg;
        thisDlg = $.openfire.dialogs.els[id];
        alert = thisDlg.find('.alert-' + type + '-text');
        if (text) {
          alert.html(text);
        }
        thisDlg.find('.alerts').css('z-index', '9999');
        return alert.parent().show();
      };
    };

    OFBootstrapController.prototype.initWizards = function() {
      var wizard, _i, _len, _ref, _results;
      _ref = $('.of-wizard');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        wizard = _ref[_i];
        if (!$.openfire.wizards) {
          $.openfire.wizards = {
            els: {}
          };
        }
        _results.push(this.initWizard($(wizard)));
      }
      return _results;
    };

    OFBootstrapController.prototype.initWizard = function(wizard) {
      var _this = this;
      wizard.find('.close-wizard').click(function(e) {
        e.preventDefault();
        wizard.parents('.of-wizard-modal').modal('hide');
        return false;
      });
      wizard.find('.close-wizard-alert').click(function(e) {
        e.preventDefault();
        $(this).parent().hide();
        wizard.find('.alerts').css('z-index', '-1');
        return false;
      });
      $.openfire.wizards.els[wizard.attr('id')] = wizard;
      return $.openfire.wizards.showAlert = function(id, type, text) {
        var alert, wiz;
        wiz = $.openfire.wizards.els[id];
        alert = wiz.find('.alert-' + type + '-text');
        if (text) {
          alert.html(text);
        }
        wiz.find('.alerts').css('z-index', '9999');
        return alert.parent().show();
      };
    };

    OFBootstrapController.prototype.initAlerts = function() {
      return $.simple_alert = {
        alert: bootbox.alert,
        confirm: bootbox.confirm,
        prompt: bootbox.prompt
      };
    };

    OFBootstrapController.prototype.initDropdowns = function() {
      return $('.dropdown-menu').on('touchstart.dropdown.data-api', function(e) {
        return e.stopPropagation();
      });
    };

    return OFBootstrapController;

  })();

  window.OFBootstrapController = OFBootstrapController;

  $.openfire.controller_classes.of_bootstrap = OFBootstrapController;

}).call(this);
