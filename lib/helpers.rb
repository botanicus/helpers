# encoding: utf-8

module Helpers
  module HtmlAttrsMixin
    def to_html_attrs
      self.inject(String.new) do |result, pair|
        key, value = pair
        result + " #{key}='#{value}'"
      end
    end
  end

  class SelfCloseTag
    attr_accessor :name, :attrs
    def initialize(name, attrs = Hash.new, &block)
      attrs.extend(HtmlAttrsMixin)
      @name, @attrs = name, attrs
      block.call(self) unless block.nil?
    end

    def [](attr)
      self.attrs[attr]
    end

    def []=(attr, value)
      self.attrs[attr] = value
    end

    # Tag.new(:form) { |form| form.data[:confirm] = "Send it now?" }
    def data
      @attrs["data-"]
    end

    def to_s
      "<#{name}#{attrs.to_html_attrs} />"
    end

    # NOTE: we can't use aliasing because it just copy the method so inheritance doesn't work as expected
    def inspect
      self.to_s
    end
  end

  class Tag < SelfCloseTag
    # content can be string, tag or an array of tags
    attr_writer :content
    def content
      @content ||= Array.new
    end

    attr_writer :indentation
    def indentation
      @indentation ||= 0
    end

    def each(&block)
      self.to_s.split("\n").each do |item|
        block.call("#{item}\n") # otherwise content-length will lie
      end
      # specially for rack
    end

    def initialize(name, content = nil, attrs = Hash.new, &block)
      attrs, content = content, nil if content.is_a?(Hash) && attrs.empty?
      self.content = ContentList.new(content, self.indentation + 1)
      super(name, attrs, &block)
    end

    def tag(*args, &block)
      self.content.push(Tag.new(*args, &block))
    end

    def to_s
      "#{"  " * self.indentation}<#{name}#{attrs.to_html_attrs}>\n#{"  " * self.indentation}#{content}\n#{"  " * self.indentation}</#{name}>"
    end
  end

  class ContentList < Array
    attr_accessor :indentation
    def initialize(items, indentation)
      self.indentation = indentation
      self.push(*items)
    end

    def to_s
      self.map do |item|
        if item.respond_to?(:indentation)
          item.indentation = self.indentation
          item
        else
          "#{"  " * self.indentation}#{item}"
        end
      end.join("\n")
    end

    def find_tag(&block)
      self.find do |item|
        block.call(item) if item.respond_to?(:name)
      end
    end

    def select_tags(&block)
      self.select do |item|
        block.call(item) if item.respond_to?(:name)
      end
    end

    def inspect
      self.to_s
    end
  end

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
