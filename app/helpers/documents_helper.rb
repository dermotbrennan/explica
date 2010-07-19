module DocumentsHelper
  def render_document_text(document)
    #logger.debug document.complex_words.join('|')
    text = document.original.gsub(/(\W|^|)(#{document.complex_words.join('|')})(\W|$)/i, '\1<span class="word">\2</span>\3').html_safe
    if text =~ /(<br|<p|<div)/
      text
    else
      text.gsub(/(\n+\s*)+/, '<br/>')
    end
  end
end
