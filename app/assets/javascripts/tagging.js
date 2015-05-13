$(document).ready(function() {
  var tagForm = $('form#trip-tag');

  var tagFormSubmitButton = tagForm.find('input[type="submit"]');
  var tagFormCheckBox     = tagForm.find('input[type="checkbox"]#trip_is_business');

  // Hide the submit button
  tagFormSubmitButton.hide();

  // Hijack the checkbox
  tagFormCheckBox.click(function(e) {

    $.ajax({
      url: tagForm.attr('action'),
      method: tagForm.attr('method'),
      data: tagForm.serialize(),
      dataType: 'json',
      success: function(resp) {
      },
      error: function(resp) {
      }
    });

  });
});
