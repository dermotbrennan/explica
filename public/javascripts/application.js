// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
(function($) {
  $(document).ready(function() {
    var inner_els = $("#main_content #sidebar_right, #main_content #original_text");

    function onWindowResize() {
      setSidebarWidth();
      setEqualHeights();
    }

    function setEqualHeights() {
      inner_els.equalHeights($(document).height() - 123);
      $("#main_content #sidebar_right").css('height', $("#main_content #sidebar_right").height() - 3); /* reduce the height by 3px to allow for a bottom border */
    }

    function setSidebarWidth() {
      $('#sidebar_right').width(($('#primary_wrapper').width()) - $('#original_text').width());
    }

    // highlight this word as visited and current in the original text
    function setCurrentWord(word) {
      $('#original_text span.word').removeClass('current');
      return $("#original_text span.word:contains("+word+")").addClass('current');
    }

    function setVisitedWord(word) {
      return $("#original_text span.word:contains("+word+")").addClass('visited');
    }

    function setCurrentAndVisitedWord(word) {
      return setCurrentWord(word).addClass('visited');
    }

    function getLocalItem(word) {
      results = $('#results_'+word);
      if (results.length > 0) {
        results.addClass('active');
        $('#sidebar_right_inner').removeClass('loading');
        return true;
      } else {
        return false;
      }
    }

    function loadDefinition(word) {
      // highlight this word as visited and current in the original text
      setCurrentAndVisitedWord(word);

      $('#sidebar_right_inner .results').removeClass('active');
      if (!getLocalItem(word)) {
        results_id = 'results_' + word
        $('#sidebar_right_inner').append('<div id="' + results_id + '" class="results active"></div>')

        $('#'+results_id).load('/definitions/'+ word, function() {
          inner_els.css("overflow", "auto");
          $('#sidebar_right_inner').removeClass('loading');
        });
      } 
    }


    setSidebarWidth();
    setEqualHeights();

    resize_original = function(event, ui) {
        setSidebarWidth();
        setEqualHeights();
      }

    $(".resizable").resizable({handles: 'e', ghost: false,
      resize: resize_original,
      start: resize_original
    });
   
    window.onresize = onWindowResize;

    // set the words in the original text as visited words
    $('#sidebar_right #history li a').each(function(i, el) {
      word = $(el).text();
      if ($(el).hasClass('current')) {
        loadDefinition(word);
      } else {
        setVisitedWord(word);
      }
    })

    words = $("#original_text span.word, #sidebar_right #history ul li a");
    if (words.length > 0) {
      words.live('click', function() {
        word =  $(this).text();
        $('#sidebar_right').removeClass('initial');
        $('#sidebar_right_inner').addClass('loading');
        $('#sidebar_right_inner').children('#message').text(word + " - loading...");

        // add this word to the history
        $('#sidebar_right #history ul li a').removeClass('current');
        word_link_text = "#"+word
        historic_word = $('#sidebar_right #history ul li a[href='+word_link_text + ']')
        if (historic_word.length > 0) {
          historic_word.addClass('current');
        } else {
          if ($('#sidebar_right #history ul').length == 0) {
            $('#sidebar_right #history').append('<ul></ul>')
          }
          $('#sidebar_right #history ul').append("<li><a href='"+word_link_text+"' class='current'>"+word+"</a></li>");
        }

        loadDefinition(word);
      })
    }
  })
})(jQuery);
