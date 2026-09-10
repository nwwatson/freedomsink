require "test_helper"

class CurrencyTest < ActiveSupport::TestCase
  test "symbol returns the correct symbol for known currencies" do
    assert_equal "$", Currency.symbol("usd")
    assert_equal "€", Currency.symbol("eur")
    assert_equal "£", Currency.symbol("gbp")
    assert_equal "$", Currency.symbol("cad")
    assert_equal "$", Currency.symbol("aud")
  end

  test "symbol falls back to dollar sign for unknown currencies" do
    assert_equal "$", Currency.symbol("xyz")
    assert_equal "$", Currency.symbol(nil)
  end

  test "format combines the symbol and formatted amount" do
    assert_equal "$10.00", Currency.format(1000, "usd")
    assert_equal "€10.50", Currency.format(1050, "eur")
    assert_equal "£5.99", Currency.format(599, "gbp")
  end

  test "format pads to two decimal places" do
    assert_equal "$10.00", Currency.format(1000, "usd")
    assert_equal "$0.05", Currency.format(5, "usd")
  end

  test "options_for_select returns label/code pairs for every supported currency" do
    options = Currency.options_for_select

    assert_includes options, [ "USD ($)", "usd" ]
    assert_includes options, [ "EUR (€)", "eur" ]
    assert_includes options, [ "GBP (£)", "gbp" ]
    assert_equal Currency::CODES.size, options.size
  end
end
