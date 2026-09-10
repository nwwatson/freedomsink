require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "valid membership" do
    membership = Membership.new(
      subscriber: subscribers(:unconfirmed),
      membership_tier: membership_tiers(:monthly),
      status: :active
    )
    assert membership.valid?
  end

  test "current scope returns active and trialing" do
    current = Membership.current
    assert current.include?(memberships(:active_membership))
    assert_not current.include?(memberships(:canceled_membership))
  end

  test "by_recency orders by created_at desc" do
    memberships_list = Membership.by_recency
    assert memberships_list.first.created_at >= memberships_list.last.created_at
  end

  test "complimentary? returns true when no stripe_subscription_id" do
    membership = Membership.new(subscriber: subscribers(:unconfirmed), membership_tier: membership_tiers(:monthly), status: :active)
    assert membership.complimentary?
  end

  test "complimentary? returns false when stripe_subscription_id present" do
    assert_not memberships(:active_membership).complimentary?
  end

  test "grant_complimentary! creates an active membership with no stripe subscription" do
    subscriber = subscribers(:unconfirmed)
    tier = membership_tiers(:annual)

    membership = Membership.grant_complimentary!(subscriber: subscriber, membership_tier: tier)

    assert membership.persisted?
    assert membership.active?
    assert membership.complimentary?
    assert_equal subscriber, membership.subscriber
    assert_equal tier, membership.membership_tier
    assert membership.current_period_end > 90.years.from_now
  end
end
