class Currency
  NAMES = {
    "usd" => "USD",
    "eur" => "EUR",
    "gbp" => "GBP",
    "cad" => "CAD",
    "aud" => "AUD"
  }.freeze

  SYMBOLS = {
    "usd" => "$",
    "eur" => "€",
    "gbp" => "£",
    "cad" => "$",
    "aud" => "$"
  }.freeze

  CODES = NAMES.keys.freeze

  class << self
    def symbol(code)
      SYMBOLS[code] || "$"
    end

    def format(cents, code)
      "#{symbol(code)}#{sprintf("%.2f", cents / 100.0)}"
    end

    def options_for_select
      NAMES.map { |code, name| [ "#{name} (#{symbol(code)})", code ] }
    end
  end
end
