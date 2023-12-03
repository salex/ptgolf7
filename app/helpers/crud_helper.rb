module CrudHelper

  def formatField(label,field)
    content_tag(:div,content_tag(:label,label.to_s.titlecase)+field,class:'field')
  end


  #NOT USED
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

  # destroyTag and ConfirmTag uses button_to with turbo_confirm
  # which was added after I created a stimulus confirm script
  def destroyTag(model_path,meth:"",confirm_msg:"",klass:"",prompt:"")
    klass= "btn-danger py-0 inline-block mr-1" if klass.blank?
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
    # puts "KLASS #{klass}"
    return button_to prompt, model_path, method: meth,form_class:klass,
      form: { data: { turbo_confirm: confirm_msg }}
  end

  def confirmTag(model_path,meth:"",confirm_msg:"",klass:"",prompt:"")
    meth = "patch" if meth.blank?
    destroyTag(model_path,meth:meth,confirm_msg:confirm_msg,klass:klass,prompt:prompt)
  end

  def destroyIcon(model_path,icon:nil)
    prompt = icon.blank? ? icon("fas fa-trash") : icon
    return button_to(prompt, model_path,
      method: 'delete',
      form_class: "btn-danger py-0.5 px-1.5 text-sm inline-block mr-1 ",
      form: { data: { turbo_confirm: "Are You Sure?" }}
      )
  end

  def linkIcon(icon,model_path,btn_class:nil)
    return link_to(icon,model_path,class:(btn_class << " text-sm "))
  end


  # # used in home/show demo
  def greenBox
    "box-border box-content m-3 p-4 bg-green-300 border-green-100 border-2 text-black"
  end

  def blueBox
    "box-border box-content m-3 p-4 bg-blue-400 border-blue-200 border-2 text-black"
  end

  # def btn_sm
  #   "ml-2 rounded-md py-1 px-3 bg-gray-200 inline-block font-medium "
  # end


end
