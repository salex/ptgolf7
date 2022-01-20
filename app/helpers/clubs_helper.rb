module ClubsHelper

  def format_phone(numb)
    # in case formated
    numb = numb.gsub(/[^\d]/,"")
    number_to_phone(numb,delimiter:'.')
  end

  def slim_text(text)
    page =  Slim::Template.new{|t| text}
    page.render.html_safe
  end

  def callout_warning(content)
    tag.div class:'w3-container w3-pale-yellow w3-leftbar w3-border-yellow w3-display-container' do 
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.br)
      concat(content)
    end
  end
  def callout_alert(content)
    tag.div class:'w3-container w3-pale-red w3-leftbar w3-border-red w3-display-container' do  
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.br)
      concat(content)
    end
  end
  def callout_info(content)
    tag.div class:'w3-container w3-pale-blue w3-leftbar w3-border-blue w3-display-container' do  
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.br)
      concat(content)
    end
  end
  def callout_success(content)
    tag.div class:'w3-container w3-pale-green w3-leftbar w3-border-green w3-display-container' do  
      concat(tag.button('&cross;'.html_safe,
        class:"absolute -top-3 -right-3 bg-red-500 hover:bg-red-600 text-2xl w-10 h-10 rounded-full focus:outline-none text-white",
          onclick:"this.parentElement.style.display='none'")) 
      concat(tag.br)
      concat(content)
    end
  end

  def slim_text(text)
    page =  Slim::Template.new{|t| text}
    page.render.html_safe
  end

  
end
