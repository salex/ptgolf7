module MyButtonsHelper
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
    "bg-red-400 hover:bg-red-600 hover:text-white border-2 border-red-800 "
  end

  def mbtn_link
    mbtn + bg_link
  end

  def mbtn_warn
    mbtn + bg_warn
  end

  def mbtn_send
    mbtn + bg_send
  end

  def mbtn_danger
    mbtn + bg_danger
  end

  # Aliases colors in case you forget link, send, warn, danger
  def mbtn_green
    mbtn_link
  end

  def mbtn_orange
    mbtn_warn
  end

  def mbtn_blue
    mbtn_send
  end

  def mbtn_red
    mbtn_danger
  end

end

