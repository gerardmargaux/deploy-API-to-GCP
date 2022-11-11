$(function() {
  $('a#text_btn').on('click', function(e) {
  e.preventDefault()
  $.getJSON('/background_process_button',
      function(data) {
      //do nothing
  });
  return false;
  });
});