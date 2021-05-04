# frozen_string_literal: true

# app/lib/api_version.rb
class ApiVersion
  attr_reader :version, :default

  def initialize(version, default = false)
    @version = version
    @default = default
  end

  # check whether version is specified or is default
  def matches?(request)
    check_headers(request.headers) || default
  end

  private

  def check_headers(headers)
    # check version from Accept headers; expect custom media type `tours`
    accept = headers[:accept]
    accept&.include?("application/vnd.tours.#{version}+json")
  end
end
