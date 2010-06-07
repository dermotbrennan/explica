module DocumentsHelper
  def render_document_text(document)
    #logger.debug document.complex_words.join('|')
    document.original.gsub(/(\W|^|)(#{document.complex_words.join('|')})(\W|$)/i, '\1<span class="word">\2</span>\3').html_safe
  end
end
