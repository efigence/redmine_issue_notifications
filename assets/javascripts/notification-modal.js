$(function() {
  $('.contextual a.icon:last-child').after( $('#notify-link').show() );
  $.datepicker.setDefaults({dateFormat: 'yy-mm-dd' });
  $('#time-picker').datetimepicker();
});
