module ApplicationHelper
  def hidden_class_if_voted(user, object)
    'hidden' if user.voted?(object)
  end

  def hidden_class_if_not_voted(user, object)
    'hidden' unless user.voted?(object)
  end
end
