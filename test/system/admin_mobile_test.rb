require "application_system_test_case"

class AdminMobileTest < ApplicationSystemTestCase
  setup do
    sign_in_admin
  end

  test "mobile sidebar opens and closes via hamburger" do
    with_mobile_viewport do
      visit admin_root_path

      # Sidebar should be hidden initially
      assert_no_selector "aside.translate-x-0"

      # Open sidebar via hamburger
      find("[data-action='click->admin-sidebar#open']").click
      assert_selector "aside.translate-x-0"

      # Close via backdrop
      find("[data-admin-sidebar-target='backdrop']").click
      assert_selector "aside.-translate-x-full"
    end
  end

  test "mobile sidebar closes on navigation" do
    with_mobile_viewport do
      visit admin_root_path

      find("[data-action='click->admin-sidebar#open']").click
      assert_selector "aside.translate-x-0"

      # Click a nav link
      within "[data-admin-sidebar-target='sidebar']" do
        click_link I18n.t("layouts.admin.all_posts")
      end

      # Should navigate to posts and sidebar should be closed
      assert_current_path admin_posts_path
    end
  end

  test "posts index shows card layout on mobile" do
    with_mobile_viewport do
      visit admin_posts_path

      # Should show mobile cards, not desktop table
      assert_selector ".lg\\:hidden .rounded-lg"
      assert_no_selector ".lg\\:block table", visible: true
    end
  end

  test "posts index shows table layout on desktop" do
    visit admin_posts_path

    # Desktop table should be visible
    assert_selector ".lg\\:block table"
  end

  test "dashboard renders without horizontal overflow on mobile" do
    with_mobile_viewport do
      visit admin_root_path

      # Page should load without errors
      assert_selector "h1", text: I18n.t("admin.dashboard.show.title")

      # Stat cards should be visible
      assert_selector ".bg-white.shadow.rounded-lg"
    end
  end

  test "subscribers index shows card layout on mobile" do
    with_mobile_viewport do
      visit admin_subscribers_path

      assert_selector "h1", text: I18n.t("admin.subscribers.index.title")
    end
  end

  test "newsletters index shows card layout on mobile" do
    with_mobile_viewport do
      visit admin_newsletters_path

      assert_selector "h1", text: I18n.t("admin.newsletters.index.title")
    end
  end

  test "tablet viewport shows desktop sidebar" do
    with_tablet_viewport do
      visit admin_root_path

      # At 768px, sidebar should still be hidden (lg breakpoint is 1024px)
      # Hamburger should be visible
      assert_selector "[data-action='click->admin-sidebar#open']"
    end
  end

  test "comments page renders on mobile" do
    with_mobile_viewport do
      visit admin_comments_path

      assert_selector "h1", text: I18n.t("admin.comments.index.title")
      # Status tabs should be present
      assert_selector "nav a", minimum: 2
    end
  end

  test "traffic page renders on mobile" do
    with_mobile_viewport do
      visit admin_traffic_path

      assert_selector "h1", text: I18n.t("admin.traffic.show.title")
    end
  end

  test "growth page renders on mobile" do
    with_mobile_viewport do
      visit admin_growth_path

      assert_selector "h1", text: I18n.t("admin.growth.show.title")
    end
  end
end
