module ApplicationHelper
  def nl2br(str)
    return str unless str.is_a?(String) && str.present?
    str.gsub(/\n/, '<br/>')
  end
end
