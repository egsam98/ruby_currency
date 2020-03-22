module JsonHelper

  # @param [String]json
  # @return [Boolean]
  def valid?(json)
    JSON.parse json
    true
  rescue
    false
  end

  # @param [String]json
  # @return [Boolean]
  def valid_and_not_empty?(json)
    !JSON.parse(json).empty?
  rescue
    false
  end
end