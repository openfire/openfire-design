// Generated by CoffeeScript 1.3.3
(function() {
  var BackProjectController;

  BackProjectController = (function() {

    function BackProjectController() {
      var _this = this;
      this.dlg = null;
      this.wizard = null;
      this.project_id = null;
      this.init = function() {
        _this.dlg = $('#back-project-dlg');
        _this.wizard = $('#donate-wizard');
        if (_this.dlg && _this.dlg.length) {
          return _this.initDialog();
        }
      };
      this.initDialog = function() {
        _this.dlg.modal({
          show: false
        });
        _this.project_id = $.openfire.page_vars.project_id;
        if (_this.wizard && _this.wizard.length) {
          _this.wizard.bootstrapWizard({
            onTabShow: _this.onShowStepCb
          });
          _this.wizard.find('.finish').click(_this.submit);
        }
        $('.vote-plus').click(_this.next_step_vote_plus);
        $('.vote-minus').click(_this.next_step_vote_minus);
        $('#donate-step-1 input[type="radio"]').click(_this.choose_donation_tier);
        $('#back-project-money-source-input').change(_this.select_money_source);
        $('#back-project-btn').click(_this.start);
        return $('#populate-fake-cc-data').click(_this.populateFakeData);
      };
      this.start = function() {
        return _this.dlg.modal('show');
      };
      this.onShowStepCb = function(tab, navigation, index) {
        if (index === 2) {
          _this.dlg.find('.nav-btn-finish').removeClass('disabled').show();
          return _this.dlg.find('.nav-btn-next').hide();
        } else {
          _this.dlg.find('.nav-btn-finish').hide();
          return _this.dlg.find('.nav-btn-next').show();
        }
      };
      this.choose_donation_tier = function() {
        var row;
        row = $(this).parents('.tier-info');
        $('#back-project .tier-selected').removeClass('tier-selected');
        row.addClass('tier-selected');
        $('#back-project-remaining-votes').val(row.find('.num-votes').html());
        $('.back-project-next-step-input').val(0);
        return $('#back-project-amount-input').val(parseInt(row.find('.dollar-amount').html()));
      };
      this.next_step_vote_plus = function() {
        var decrement, increment, remaining;
        increment = $(this).parent().find('.back-project-next-step-input');
        decrement = $('#back-project-remaining-votes');
        remaining = parseInt(decrement.val());
        if (remaining > 0) {
          increment.val(parseInt(increment.val()) + 1);
          return decrement.val(remaining - 1);
        }
      };
      this.next_step_vote_minus = function() {
        var decrement, increment, remaining;
        decrement = $(this).parent().find('.back-project-next-step-input');
        increment = $('#back-project-remaining-votes');
        remaining = parseInt(decrement.val());
        if (remaining > 0) {
          increment.val(parseInt(increment.val()) + 1);
          return decrement.val(remaining - 1);
        }
      };
      this.select_money_source = function() {
        var el, _i, _len, _ref, _results;
        _ref = $('#use-new-cc').find('input');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          el = _ref[_i];
          if ($(this).val()) {
            $(el).val('');
            _results.push(el.disabled = true);
          } else {
            _results.push(el.disabled = false);
          }
        }
        return _results;
      };
      this.submit = function() {
        var el, params, radio, radios, tier, votes, _i, _j, _len, _len1, _ref;
        if (_this.dlg.find('.nav-btn-finish').hasClass('disabled')) {
          return;
        }
        _this.dlg.find('.nav-btn-finish').addClass('disabled');
        votes = [];
        _ref = $('.back-project-next-step-input');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          el = _ref[_i];
          votes.push({
            id: el.id.match(/next-step-(\w+)/)[1],
            num_votes: parseInt($(el).val())
          });
        }
        tier = '';
        radios = $('input[name="tier"]');
        for (_j = 0, _len1 = radios.length; _j < _len1; _j++) {
          radio = radios[_j];
          if (radio.checked) {
            tier = $(radio).val();
            break;
          }
        }
        params = {
          user: $('#back-project-backer').val(),
          project: _this.project_id,
          tier: tier,
          amount: $('#back-project-amount-input').val(),
          next_step_votes: JSON.stringify(votes),
          money_source: $('#back-project-money-source-input').val(),
          new_cc: JSON.stringify({
            cc_num: $('#back-project-cc-num-input').val(),
            ccv: $('#back-project-cc-ccv-input').val(),
            expire_month: $('#back-project-cc-month-input').val(),
            expire_year: $('#back-project-cc-year-input').val(),
            user_name: $('#back-project-cc-name-input').val(),
            email: $('#back-project-cc-email-input').val(),
            address1: $('#back-project-cc-address-1-input').val(),
            address2: $('#back-project-cc-address-2-input').val(),
            city: $('#back-project-cc-city-input').val(),
            state: $('#back-project-cc-state-input').val(),
            country: $('#back-project-cc-country-input').val(),
            zipcode: $('#back-project-cc-zipcode-input').val(),
            save_for_reuse: $('#back-project-cc-save-input').attr('checked') === 'checked'
          })
        };
        return $.ajax({
          type: 'POST',
          url: '/_api/v1/back_project/',
          data: params,
          success: function(response) {
            return $.openfire.wizards.showAlert('donate-wizard', 'success', null);
          },
          error: function(response) {
            _this.dlg.find('.nav-btn-finish').removeClass('disabled');
            return $.openfire.wizards.showAlert('donate-wizard', 'error', 'There was an error: ' + response.responseText);
          }
        });
      };
      this.detect_cc_type = function() {
        var type, val;
        val = this.val();
        type = '';
        if (/^4/.test(val)) {
          type = 'Visa';
        }
        if (/^(34|37)/.test(val)) {
          type = 'American Express';
        }
        if (/^5[1-5]/.test(val)) {
          type = 'MasterCard';
        }
        if (/^6011/.test(val)) {
          type = 'Discover';
        }
        $('#back-project-cc-type-display').html(type);
        return false;
      };
      this.populateFakeData = function() {
        $('#back-project-cc-num-input').val('4003830171874018');
        $('#back-project-cc-ccv-input').val('123');
        $('#back-project-cc-month-input').val('12');
        $('#back-project-cc-year-input').val('2015');
        $('#back-project-cc-name-input').val('Fakie McFakerton');
        $('#back-project-cc-email-input').val('Fakie@McFakerton.com');
        $('#back-project-cc-address-1-input').val('123 Fake St.');
        $('#back-project-cc-address-2-input').val();
        $('#back-project-cc-city-input').val('Las Vegas');
        $('#back-project-cc-state-input').val('NV');
        $('#back-project-cc-country-input').val('US');
        $('#back-project-cc-zipcode-input').val('89104');
        return $('#back-project-cc-save-input').attr('checked', 'checked');
      };
    }

    return BackProjectController;

  })();

  window.BackProjectController = BackProjectController;

  $.openfire.controller_classes.back_project = BackProjectController;

}).call(this);