# Цепочка обязанностей
class ChainService
  class Builder
    def initialize
      @instance = ChainService.new
    end

    # Добавить обработчик цепочки
    # @param [Proc]block
    # @return [Builder]
    def add_handler(&block)
      @instance.handlers << block
      self
    end

    # Тип ошибки, при которой необходимо вызывать следующий по порядку обработчик цепочки
    # @param [Class<StandardError>]error_class
    def error(error_class)
      @instance.error_class = error_class
      self
    end

    # @return [ChainService]
    def create; @instance end
  end

  private_constant :Builder
  attr_reader :handlers
  attr_accessor :error_class

  # @return [Builder]
  def self.build; Builder.new end

  def initialize
    @handlers = []
    @error_class = StandardError
  end

  # Вызов цепочки, начиная с первого обработчика
  # @raise [@error_class]
  def call!
    @handlers.each_with_index do |x, i|
      begin
        return x.call
      rescue @error_class => e
        raise e if i == @handlers.size - 1
      end
    end
  end
end


class CurrenciesChainService < ChainService

  # Цепочка сервисов выдачи валюты формируется на основе имен классов в .env
  # @param [String]base
  # @return [CurrenciesChainService]
  def self.from_env(base)
    builder = build.error(Faraday::ConnectionFailed)
    ENV["CURRENCY_SERVICES_CHAIN"].split(/\s*,\s*/).each do |c|
      method = c.constantize.new.method(:get_currency!)
      builder = builder.add_handler { method.parameters.empty?? method.call: method.call(base) }
    end
    builder.create
  end
end