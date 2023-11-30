module CommentsHelper

  def css_classes(stylesheet="ported.css")
    filepath = Rails.root.join("app/assets/stylesheets",stylesheet)
    results = []
    if File.file?(filepath)
      content = File.read(filepath)
      #css clases start with . and end with [,:. ]
      content.scan(/\.[^\,^\:^\{^\.^\s]+/).uniq.sort.each do |i|
        # filter out classes that picked up a .[number] as a class
        results << i + " - " + stylesheet unless i[1].match(/\d/)
      end
    end
    results
  end

end
