module MarkupsHelper

  def markdown_text(text)
    if text.include?(".slim")
      # page =  Slim::Template.new{|t| text}
      # page.render.html_safe
      render inline: text, type: :slim

    else
      options = {
        :autolink => true,
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true
      }
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
      markdown.render(text).html_safe
    end
  end

  def kramdown_text(text)

    html = Kramdown::Document.new(text, syntax_highlighter: :coderay, syntax_highlighter_opts: {line_numbers: nil}).to_html.html_safe

    content_tag(:div,html,class:'w3-row-padding markdown-body')
  end

end
