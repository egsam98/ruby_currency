RailsIOC::Dependencies.define do

  class CurrenciesChainService
    def self.new
      ChainService.build
          .add_handler(-> base { ExchangeRatesApiService.new.get_currency! base })
          .add_handler(-> { FixerApiService.new.get_currency! })
          .error(Faraday::ConnectionFailed)
          .create
    end
  end


  prototype :currencies_chain_service, CurrenciesChainService

  controller Api::CurrenciesController, {
      currencies_chain_service: ref(:currencies_chain_service),
  }
end