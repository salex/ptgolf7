module ComponentsHelper
  def to_tw(component)
    component = component.gsub('.',' ') # allow slim . classes
    arr = component.split(' ') # convert to array
    klasses = []
    arr.each do |cls|
      meth = cls.gsub('-',"_")
      if ComponentsHelper.instance_methods.include?(meth.to_sym)
        cls_str = instance_eval(meth)
        meth_classes = cls_str.split(' ')
        meth_classes.each{|i| klasses << i}
      else
        klasses << cls # an normal non-component class
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
    "p-0.5 border border-gray-300 text-gray-300 hover:text-white pt-blue"
  end
  def btn_info
    btn + "bg-blue-400 text-blue-link hover:text-blue-100"
  end

  def btn_warning
    btn + "bg-orange hover:text-yellow-200"
  end

  def btn_green
    btn + "bg-green-500 hover:text-green-100"
  end

  def btn_danger
    btn + "bg-red-500 hover:text-red-200"
  end

  def btn_success
    btn + "bg-success hover:bg-green-700"
  end

  def btn_secondary
    btn + "bg-secondary"
  end

  def flashAlert(type)
    case type
    when 'danger'
      return "bg-red-200 text-red-600"
    when 'info'
      return "bg-blue-200 text-blue-600"
    when 'success'
      return "bg-green-200 text-green-600"
    when 'warning'
      return "bg-yellow-400 text-yellow-800"
    else
      return "bg-gray-200 text-gray-600"
    end
  end

  def destroyConfirmTag(model_path,meth:"",confirm_msg:"",klass:"",prompt:"")
    # note button_to add 4px padding, don't use btn class, set py to px
    klass= to_tw('btn-danger mr-2 inline-block py-px') if klass.blank?
    confirm_msg = "Are You Sure?" if confirm_msg.blank?
    meth = "delete" if meth.blank?
    url_type = model_path.class
    if prompt.blank?
      if url_type == String
        prompt = "Delete"
      else
        prompt = "Delete #{model_path.class.name}"
      end
    end
    node = content_tag(:div, class: klass,
      data:{
        controller:"actionConfirm", 
        action:"click->actionConfirm#confirm",
        actionConfirm_cmsg_value:confirm_msg
      }) do
        content_tag(:div) do
          concat(tag.span(prompt))
          concat(button_to( '',model_path, method: "#{meth}",class:" hidden",data:{actionConfirm_target:"submit"}))
        end
      end
    node 
  end

  def actionConfirmTag(model_path,meth:"",confirm_msg:"",klass:"",prompt:"")
    # note button_to add 4px padding, don't use btn class, set py to px
    klass= to_tw('btn-warning mr-2 inline-block py-px') if klass.blank?
    confirm_msg = "Are You Sure?" if confirm_msg.blank?
    meth = "patch" if meth.blank?
    url_type = model_path.class
    if prompt.blank?
      if url_type == String
        prompt = "Confirm Action"
      else
        prompt = "Confirm #{model_path.class.name}"
      end
    end
    node = content_tag(:div, class: klass,
      data:{
        controller:"actionConfirm", 
        action:"click->actionConfirm#confirm",
        actionConfirm_cmsg_value:confirm_msg
      }) do
        concat(tag.span(prompt))
        concat(button_to( '',model_path, method: "#{meth}",class:"hidden",data:{actionConfirm_target:"submit"}))
      end
    node 
  end

  # private

  # def set_prompt(url,prompt)
  #   url_type = model_url.class
  #   if prompt.blank?
  #     if url == String
  #       prompt = "Confirm Action"
  #     else
  #       prompt = "Confirm #{url.class.name}"
  #     end
  #   end
  #   prompt 
  # end


  # def delete_button(model,confirm_msg:"",klass:"",prompt:"")
  #  klass= "#{btnDanger} inline-block" if klass.blank?
  #   confirm_msg = "Are You Sure?" if confirm_msg.blank?
  #   prompt = "Delete #{model.class.name}" if prompt.blank?
  #   node = content_tag(:div, class: klass,
  #     data:{
  #       controller:"confirm_delete", 
  #       action:"click->confirm_delete#confirm",
  #       destroyConfirm_cmsg_value:confirm_msg
  #     }){
  #     concat(tag.span(prompt))
  #     concat(button_to( '',model, method: :delete,class:"hidden",data:{destroyConfirm_target:"submit"}))
  #   }
  #   node 
  # end

end
