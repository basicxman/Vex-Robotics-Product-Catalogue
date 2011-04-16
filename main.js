$(document).ready(function() {

  $(".description-row").click(function() {
    if ($(this).children("span.full-description").css("display") == "none") {
      $(this).children(".short-description").hide();
      $(this).children("span.full-description").show();
    } else {
      $(this).children("span.full-description").hide();
      $(this).children(".short-description").show();
    }
  });

});
