class HexColorValidator < ActiveModel::EachValidator
  FORMAT = /\A#[0-9a-fA-F]{6}\z/

  def validate_each(record, attribute, value)
    return if value.to_s.match?(FORMAT)

    record.errors.add(attribute, options[:message] || :hex_color)
  end
end
