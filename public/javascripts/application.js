// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict();

jQuery(document).ready(function() {

  words = jQuery("#original_text span.word");
  if (words.length > 0) {
    words.click(function() {
      alert(jQuery(this).html())
    })
  }


});

