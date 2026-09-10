require "test_helper"

class HexColorValidatorTest < ActiveSupport::TestCase
  class ColorModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :color, :string

    validates :color, hex_color: true
  end

  class OptionalColorModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :color, :string

    validates :color, hex_color: true, allow_blank: true
  end

  class CustomMessageColorModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :color, :string

    validates :color, hex_color: { message: "must be a valid hex color (e.g. #6B7280)" }
  end

  test "accepts a valid 6-digit hex color" do
    model = ColorModel.new(color: "#1a1a2e")
    assert model.valid?
  end

  test "accepts uppercase hex digits" do
    model = ColorModel.new(color: "#AABBCC")
    assert model.valid?
  end

  test "rejects a non-hex string" do
    model = ColorModel.new(color: "not-a-color")
    assert_not model.valid?
    assert_includes model.errors[:color], "must be a valid hex color (e.g. #1a1a2e)"
  end

  test "rejects a 3-digit shorthand hex color" do
    model = ColorModel.new(color: "#fff")
    assert_not model.valid?
  end

  test "rejects a blank value by default" do
    model = ColorModel.new(color: "")
    assert_not model.valid?
  end

  test "rejects nil by default" do
    model = ColorModel.new(color: nil)
    assert_not model.valid?
  end

  test "allows blank when allow_blank is set" do
    model = OptionalColorModel.new(color: "")
    assert model.valid?
  end

  test "still validates format when allow_blank is set and a value is present" do
    model = OptionalColorModel.new(color: "not-a-color")
    assert_not model.valid?
  end

  test "uses a custom message when provided" do
    model = CustomMessageColorModel.new(color: "not-a-color")
    assert_not model.valid?
    assert_includes model.errors[:color], "must be a valid hex color (e.g. #6B7280)"
  end
end
