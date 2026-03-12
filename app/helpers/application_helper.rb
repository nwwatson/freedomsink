module ApplicationHelper
  def author_link(user, **options)
    identity = user.identity
    if identity.handle.present?
      link_to identity.name, author_path(identity, handle: identity.handle),
        class: options.delete(:class) || "text-link",
        **options
    else
      content_tag(:span, identity.name, **options)
    end
  end
end
