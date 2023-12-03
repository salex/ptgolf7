module ButtonsHelper
  # A basic consistant button
  def mbtn
    "py-1 px-2 mr-1 rounded-md text-lg font-bold "
  end

  # Button colors
  def bg_link
    "bg-green-400 hover:bg-green-700 hover:text-white  border-2 border-green-600 "
  end
  def bg_warn
    "bg-amber-400 hover:bg-amber-600 hover:text-white border-2 border-amber-600 "
  end
  def bg_send
    "bg-blue-400 hover:bg-blue-700 hover:text-white border-2 border-blue-600 "
  end
  def bg_danger
    "bg-red-500 hover:bg-red-600 hover:text-white border-2 border-red-600 "
  end

  def btn_link
    mbtn + bg_link
  end

  def btn_warn
    mbtn + bg_warn
  end

  def btn_send
    mbtn + bg_send
  end

  def btn_danger
    mbtn + bg_danger
  end

  # def btni_danger
  #   mbtn + bg_danger + " py-0 "
  # end


  # Aliases colors in case you forget link, send, warn, danger
  def btn_green
    btn_link
  end

  def btn_orange
    btn_warn
  end

  def btn_blue
    btn_send
  end

  def btn_red
    btn_danger
  end

  def btnSubmit
    "mr-1 px-1 py-2 rounded-lg cursor-pointer bg-[#2040b0] hover:bg-[#2563eb] font-bold text-blue-100 border-2 border-blue-500 "
  end

end

