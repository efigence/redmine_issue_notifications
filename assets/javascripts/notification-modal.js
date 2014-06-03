$(function() {
  $.modal.defaults = $.extend({}, $.modal.defaults, {
    zIndex: 9999
  });
  $('.contextual a.icon:last-child').after( $('#notify-link').show() );
  $.datepicker.setDefaults({dateFormat: 'yy-mm-dd' });
  $('#time-picker').datetimepicker();
});
