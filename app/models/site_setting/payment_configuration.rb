module SiteSetting::PaymentConfiguration
  extend ActiveSupport::Concern

  SUPPORTED_CURRENCIES = Currency::NAMES.to_h { |code, name| [ code, "#{name} (#{Currency.symbol(code)})" ] }.freeze

  included do
    encrypts :stripe_secret_key, deterministic: false
    encrypts :stripe_publishable_key, deterministic: false
    encrypts :stripe_webhook_secret, deterministic: false

    validates :payments_currency, inclusion: { in: SUPPORTED_CURRENCIES.keys }, allow_blank: true
  end

  def payments_configured?
    stripe_secret_key.present? && stripe_publishable_key.present?
  end

  def currency_symbol
    Currency.symbol(payments_currency)
  end
end
