module Inflector
  def pluralize(str)
    str.to_s.gsub(%r{^s$}im, "#{$1}s")
  end

  def singularize(str)
    str.to_s.gsub(%r{s$}im, "")
  end

  def jsize(str)
    str.to_s.split("_").each_with_index.map { |s, i| i.zero? ? s.downcase : s.capitalize }.join ""
  end
end
