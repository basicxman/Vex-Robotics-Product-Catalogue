$(document).ready(function() {

  $(".description-row").click(function() {
    var id = $(this).parent().attr('id');
    if ($(this).children("span.full-description").css("display") == "none") {
      $(this).children(".short-description").hide();
      $(this).children().each(function() { $(this).disableSelection(); });
      $(this).children("span.full-description").show();
      var reenable = '$("#' + id + '").children().each(function() { $(this).enableSelection(); });';
      setTimeout(reenable, 500);
    } else {
      $(this).children("span.full-description").hide();
      $(this).children().each(function() { $(this).disableSelection(); });
      $(this).children(".short-description").show();
      var reenable = '$("#' + id + '").children().each(function() { $(this).enableSelection(); });';
      setTimeout(reenable, 500);
    }
  });

});
