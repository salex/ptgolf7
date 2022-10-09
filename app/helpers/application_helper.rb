module ApplicationHelper
  include Pagy::Frontend
  def page_title
    content_for(:page_title) || Rails.application.class.to_s.split('::').first
  end

  def crud_actions
    %w( index show new edit create update )
  end

  def active_nav_item(controller, actions)
    'active' if active_actions?(controller, actions)
  end

  def sort_link_turbo(attribute, *args)
    sort_link(attribute, *args.push({}, { data: { turbolinks_action: 'replace' } }))
  end

  def icon(klass, text = nil)
    icon_tag = tag.i(class: klass)
    text_tag = tag.span text
    text ? tag.span(icon_tag + text_tag) : icon_tag
  end

  def btn_cancel_list(path,desc=false)
    link_to icon('fas fa-list',desc ? 'Cancel - List' : nil), path, title: 'List it', class: 'btn btn-orange mr-2'
  end

  def btn_cancel_show(path,desc=false)
    link_to icon('fas fa-eye',desc ? "Cancel - Show" : nil ),  path, title: 'Show it', class: 'btn btn-orange mr-2'
  end

  def icon_list
    'fas fa-list'
  end

  def icon_eye
    'fas fa-eye'
  end

  def icon_arrow_left
    'fas fa-arrow-left'
  end

  def icon_arrow_right
    'fas fa-arrow-right'
  end

  def np(number, options = {})
    number_with_precision number, options
  end

  def nd(number, options = {})
    number_with_delimiter number, options
  end

  def localize(object, options = {})
    super(object, options) if object
  end
  alias :l :localize

  
  def inspect_session
    inspect = {}
    session.keys.each do |k|
      inspect[k] = session[k]
    end
    inspect
  end
  alias session_inspect inspect_session



  private
    def active_actions?(controller, actions)
      params[:controller].include?(controller) && actions.include?(params[:action])
    end
end
