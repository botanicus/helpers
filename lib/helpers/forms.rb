# encoding: utf-8

module Helpers
  class Forms
    # Form.new("/posts/create") do |form|
    #   form.text_field "post[title]"
    #   form.text_area "post[body]"
    #   form.submit "Create"
    # end
    class Form < Tag
      def initialize
        super(:form, Array.new, action)
      end
    end

    # Form.new(@post, "/posts/create") do |form|
    #   form.text_field :title
    #   form.text_area :body
    #   form.submit "Create"
    # end
    class FormFor < Form
      def initialize(object, action)
      end
    end

    # ButtonToDelete.new(post_path(@post), confirm: "Are you sure?")
    class ButtonTo < Tag
      def initialize(title, action, attrs = Hash.new, &block)
        button = Tag.new(:button, title, attrs.merge(type: "submit"))
        super(:form, button, action: action, &block)
      end
    end

    class ButtonToDelete < ButtonTo
      def initialize(title, action = nil, attrs = Hash.new)
        action, title = title, "Destroy" if title && action.nil?
        super(title, action + "?_method=DELETE", attrs.merge(name: name, value: value))
      end
    end
  end
end
