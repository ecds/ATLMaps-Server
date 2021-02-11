# frozen_string_literal: true

# /app/models/concerns/sanitize.rb
# Mixin to sanitize HTML strings.
module Sanitize
  def sanitize_value(value)
    sanitizer = Rails::Html::SafeListSanitizer.new
    # rubocop:disable Style/CaseLikeIf, Style/EmptyElse
    if value.is_a?(String)
      sanitizer.sanitize(value)
    elsif value.is_a?(Numeric)
      value
    else
      nil
    end
    # rubocop:enable Style/CaseLikeIf, Style/EmptyElse
  end
end