# encoding: utf-8

require "uri"

module Rango
  module Helpers
    # @since 0.0.1
    def copyright(from)
      now = Time.now.year
      now.eql?(from) ? now : "#{from} - #{now}"
    end

    # @since 0.0.2
    def link_to(name, url, options = Hash.new)
      default = {href: URI.escape(url), title: name.to_s.gsub(/'/, '&apos;')}
      Tag.new(:a, name, default.merge(options))
    end

    # @since 0.0.2
    def link_item(name, url)
      Tag.new(:li, link_to(name, url))
    end

    # @since 0.0.2
    # mail_to "joe@example.com"
    # => "<a href='mailto:joe@example.com'>joe@example.com</a>"
    # mail_to "joe@example.com", "Title"
    # => "<a href='mailto:joe@example.com'>Title</a>"
    def mail_to(mail, text = mail)
      mail.gsub!("@" "&#x40;")
      Tag.new(:a, text, href: "mailto:#{mail}")
    end

    # @since 0.0.2
    def error_messages_for(model_instance)
      Tag.new(:ul) do
        messages = model_instance.errors.full_messages
        messages.map { |message| tag :li, message }
      end
    end

    def truncate(text, *args)
      options = args.extract_options!
      unless args.empty?
        options[:size]     = args[0] || 75
        options[:omission] = args[1] || "..."
      end
      options = {size: 75, omission: "..."}.merge(options)
      text.scan(/(\S+)(\s+)/)[0..options[:size]].flatten.join << options[:omission] if text
    end
  end
end
