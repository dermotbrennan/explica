// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  $(document).ready(function() {
    words = $("#original_text span.word");
    if (words.length > 0) {
      words.click(function() {
        word =  $(this).text();
        $('#definition').html('Loading '+ word + '...');
        $('#definition').load('/definitions/'+ word, function() {
          
        });
      })
    }
  })
})(jQuery);

