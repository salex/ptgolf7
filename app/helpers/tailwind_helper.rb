module TailwindHelper

  def as_tw(class_str)
    class_str.gsub!('.',' ') # allow slim . classes, replace . with space
    arr = class_str.split(' ') # convert to array
    klasses = [] 
    arr.each do |cls|
      meth = cls.gsub('-',"_") #see if its defined in component with underscore
      if TailwindHelper.instance_methods.include?(meth.to_sym)
        cls_str = instance_eval(meth) # get the component classes, could be snakeCase method
        meth_classes = cls_str.split(' ') # convert to array
        meth_classes.each{|i| klasses << i} # add component classes to klasses
      else
        klasses << cls # a non-component class
      end
    end
    return(klasses.uniq.to_sentence(words_connector:' ',last_word_connector:' '))
    # return a sting of stylesheet classes and any component classes
  end

  def btn
    "py-1 px-2 rounded-md font-lg font-bold "
  end

  def w3_btn
    "py-2 px-4 font-lg font-bold  bg-blue-800 text-white  hover:text-black hover:bg-slate-400"
  end

  def btnInfo
    self.btn + "bg-blue-800 text-white hover:text-blue-300"
  end

end
