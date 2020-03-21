require 'dry-validation'


module ValidationHelper

  # Бросать в случае ошибки валидации с помощью dry-validation
  class ValidationError < StandardError
    attr_reader :errors

    # @param [Hash] errors
    def initialize(errors)
      @errors = errors
    end
  end

  # Переопределенный метод call бросает исключение ValidationError
  class Contract < Dry::Validation::Contract

    # @param [Hash] input
    # @raise [ValidationError] if validation failed
    # @return nil
    def call(input)
      res = super input
      if res.failure?
        info = res.errors.to_h
        info.each {|k, arr| info[k] = arr.map{ |err| "#{err}, provided: #{input[k]}"}}
        raise ValidationError.new(info)
      end
    end
  end
end
