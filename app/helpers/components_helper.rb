module ComponentsHelper
  def to_tw(class_str)
    component = class_str.gsub('.',' ') # allow slim . classes
    arr = class_str.split(' ') # convert to array
    klasses = []
    arr.each do |cls|
      meth = cls.gsub('-',"_") #see if its defined in component
      if ComponentsHelper.instance_methods.include?(meth.to_sym)
        cls_str = instance_eval(meth) # get the component classes
        meth_classes = cls_str.split(' ')
        meth_classes.each{|i| klasses << i} # add component classes to klasses
      else
        klasses << cls # a normal non-component class
      end
    end
    return(klasses.uniq.to_sentence(words_connector:' ',last_word_connector:' '))
    # return a sting of classes x and any component class
  end

  def sidebar_menu
    "btn-sqr-blue text-center font-bold border border-zinc-100 py-1"
  end

  def player_menu
    "btn-sqr-blue  font-bold border border-zinc-100 py-px"
  end


  def green_box
    "box-border box-content m-3 p-4 bg-green-300 border-green-100 border-2 text-black"
  end

  def blue_box
    "box-border box-content m-3 p-4 bg-blue-400 border-blue-200 border-2 text-black"
  end

  def btn
    "py-1 px-2 text-black hover:text-white rounded font-lg font-bold "
  end

  def pt_btn
    "py-1 px-2 text-black hover:text-white rounded font-lg font-bold "
  end

  def btn_sqr
    "p-0.5 border border-gray-300 text-gray-300 hover:text-white pt-blue "
  end
  def btn_info
    btn << " " << "bg-blue-400 text-blue-link hover:text-blue-100 "
  end

  def btn_warning
    btn + "bg-orange hover:text-yellow-200 "
  end

  def btn_green
    btn + "bg-green-500 hover:text-green-100 "
  end

  def btn_danger
    btn + "bg-red-500 hover:text-white "
  end

  def btn_success
    btn + "bg-success hover:bg-green-700 "
  end

  def btn_secondary
    btn + "bg-secondary "
  end

  def btn_destroy
    "inline-block bg-red-500 py-0 rounded hover:text-white font-bold px-2 mr-1"
  end


end
