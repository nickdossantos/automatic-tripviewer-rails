module ApplicationHelper

  def active_nav(args={})
    controllers = args.delete(:controllers).split(',').map(&:strip)
    actions     = args.delete(:actions).split(',').map(&:strip)

    if contains_controller?(controllers) && contains_action?(actions)
      'active'
    end
  end

  def contains_controller?(*controllers)
    controllers.flatten.include?(controller.controller_name)
  end

  def contains_action?(*actions)
    actions.flatten.include?(controller.action_name)
  end

  def hard_brakes_class(count)
    if count.to_i > 0
      "someHardBrakes"
    else
      "noHardBrakes"
    end
  end

  def hard_accels_class(count)
    if count.to_i > 0
      "someHardAccels"
    else
      "noHardAccels"
    end
  end

  def speeding_class(count)
    if count.to_i > 0
      "someSpeeding"
    else
      "noSpeeding"
    end
  end
end
