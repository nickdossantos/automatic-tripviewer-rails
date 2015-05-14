$(document).ready(function() {
  // Use JS history for back buttons
  var backButtons = $('a.back.btn');

  backButtons.click(function(e) {
    history.back();

    return false;
  });
});
