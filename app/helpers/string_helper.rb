module StringHelper
  # @param [String]str
  # @return [String]
  def uncapitalize (str)
    str[0] = str[0].downcase unless str.nil?
    str
  end
end