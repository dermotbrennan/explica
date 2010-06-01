// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  $(document).ready(function() {
    //$("#main_content").splitter();
    $("#main_content>div").equalHeights(jQuery(document).height() - 41);

    var inner_els = $("#main_content #sidebar_right, #main_content #original_text");
    resize_original = function(event, ui) {
        $('#sidebar_right').width((jQuery('#primary_wrapper').width()) - $('#original_text').width() - 28);
        //inner_els.css("height", "auto");

        inner_els.equalHeights(jQuery(document).height() - 60);
      }

    $(".resizable").resizable({ handles: 'e', ghost: false,
      resize: resize_original,
      start: resize_original
    });

    $('#sidebar_right').width((jQuery('#primary_wrapper').width()) - $('#original_text').width() - 28);


    words = $("#original_text span.word, #sidebar_right #history ul li a");
    if (words.length > 0) {
      words.live('click', function() {
        word =  $(this).text();
        $('#sidebar_right').removeClass('initial');
        $('#sidebar_right_inner').prepend("<h2>"+ word + " - loading...</h2>");
        $('#sidebar_right #history ul li a').removeClass('current');
        word_link_text = "#"+word
        historic_word = $('#sidebar_right #history ul li a[href='+word_link_text + ']')
        if (historic_word.length > 0) {
          historic_word.addClass('current');
        } else {
          $('#sidebar_right #history ul').append("<li><a href='"+word_link_text+"' class='current'>"+word+"</a></li>");
        }

        
        $('#sidebar_right_inner').load('/definitions/'+ word, function() {
          inner_els.css("overflow", "auto");
        });
      })
    }
  })
})(jQuery);