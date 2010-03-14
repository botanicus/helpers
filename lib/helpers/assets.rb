# encoding: utf-8

# TODO: javascript "application" => media/javascripts/application.js
# ... but what if I need full path? It should be tested if file exist, of course
# javascript Path.new("design/whatever.js")

begin
  require "media-path"
rescue LoadError
  raise LoadError, "You have to install media-path gem!"
end

module Helpers
  module Assets
    # @since 0.0.2
    def self.root
      @@root
    rescue NameError
      if Dir.exist?("public")
        MediaPath.new("public")
      else
        raise "You have to set Helpers::Assets.root!"
      end
    end

    # @since 0.0.2
    def self.root=(root)
      case root
      when String
        @@root = MediaPath.new(root)
      when Pathname
        @@root = MediaPath.new(root.to_s)
      when MediaPath
        @@root = root
      else
        raise ArgumentError, "Helpers::Assets.root has to be a MediaPath!"
      end
    end

    # @since 0.0.2
    def javascript(basename)
      path = Assets.root.join("javascripts/#{basename}.js")
      Tag.new(:script, src: path.url, type: "text/javascript")
    end

    # @since 0.0.2
    def stylesheet(basename, attrs = Hash.new)
      path = Assets.root.join("stylesheets/#{basename}")
      default = {href: path.url, media: 'screen', rel: 'stylesheet', type: 'text/css'}
      SelfCloseTag.new(:link, default.merge(attrs))
    end

    def image(basename, attrs = Hash.new)
      path = Assets.root.join("images/#{basename}")
      default = {src: path.url, alt: path.basename}
      SelfCloseTag.new(:img, default.merge(attrs))
    end

    # @since 0.0.2
    def javascripts(*names)
      names.map { |name| self.javascript(name) }.join("\n")
    end

    # @since 0.0.2
    def stylesheets(*names)
      names.map { |name| self.stylesheet(name) }.join("\n")
    end
  end
end
