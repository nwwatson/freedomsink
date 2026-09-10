require "application_system_test_case"

class ColorPairTest < ApplicationSystemTestCase
  setup do
    sign_in_admin
  end

  test "typing a valid hex in the dark theme text field updates the color input" do
    SiteSetting.current.update!(dark_theme: "custom")
    visit edit_admin_settings_path

    text_field = find("input[name='site_setting[dark_bg_color]'][type='text']")
    text_field.fill_in with: "#123abc"

    color_field = find("input[name='site_setting[dark_bg_color]'][type='color']", visible: :all)
    assert_equal "#123abc", color_field.value
  end

  test "typing an invalid hex in the dark theme text field leaves the color input unchanged" do
    SiteSetting.current.update!(dark_theme: "custom")
    visit edit_admin_settings_path

    color_field = find("input[name='site_setting[dark_bg_color]'][type='color']", visible: :all)
    original_value = color_field.value

    text_field = find("input[name='site_setting[dark_bg_color]'][type='text']")
    text_field.fill_in with: "not-a-color"

    assert_equal original_value, color_field.value
  end

  test "typing an invalid hex in the email branding text field leaves the color input unchanged" do
    visit edit_admin_newsletter_settings_path

    color_field = find("input[name='site_setting[email_accent_color]'][type='color']", visible: :all)
    original_value = color_field.value

    text_field = find("input[name='site_setting[email_accent_color]'][type='text']")
    text_field.fill_in with: "nope"

    assert_equal original_value, color_field.value
  end
end
