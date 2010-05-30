// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  $(document).ready(function() {
    //$("#main_content").splitter();
    $("#main_content>div").equalHeights(jQuery(document).height() - 41);

    resize_original = function(event, ui){
        inner_els = $("#main_content #sidebar_right, #main_content #original_text");
        $('#sidebar_right').width((jQuery('#primary_wrapper').width()) - $('#original_text').width() - 3);
        //inner_els.css("height", "auto");
        inner_els.equalHeights(jQuery(document).height() - 60);
      }

    $(".resizable").resizable({ handles: 'e', ghost: false,
      resize: resize_original,
      start: resize_original
    });

    $('#sidebar_right').width((jQuery('#primary_wrapper').width()) - $('#original_text').width() - 3);



    words = $("#original_text span.word");
    if (words.length > 0) {
      words.click(function() {
        word =  $(this).text();
        $('#sidebar_right').removeClass('initial');
        $('#sidebar_right_inner').prepend("<h2>"+ word + " - loading...</h2>");

        $('#sidebar_right_inner').load('/definitions/'+ word, function() {
        });
      })
    }
  })
})(jQuery);