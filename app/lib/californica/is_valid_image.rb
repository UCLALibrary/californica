# frozen_string_literal: true

module Californica
  class IsValidImage
    def initialize(image:)
      @image = image
    end

    def valid?
      MiniMagick::Image.new(@image).identify
      return true
    rescue MiniMagick::Error
      return false
    end
  end
end
