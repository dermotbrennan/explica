// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  $(document).ready(function() {
    //$("#main_content").splitter();

    words = $("#original_text span.word");
    if (words.length > 0) {
      words.click(function() {
        word =  $(this).text();
        $('#sidebar_right').removeClass('initial');
        $('#sidebar_right').html("<h2>"+ word + " - loading...</h2>");

        $('#sidebar_right').load('/definitions/'+ word, function() {
          
        });
      })
    }
  })
})(jQuery);

