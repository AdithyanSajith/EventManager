require "test_helper"

class ManagedEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @managed_event = managed_events(:one)
  end

  test "should get index" do
    get managed_events_url
    assert_response :success
  end

  test "should get new" do
    get new_managed_event_url
    assert_response :success
  end

  test "should create managed_event" do
    assert_difference("ManagedEvent.count") do
      post managed_events_url, params: { managed_event: { category_id: @managed_event.category_id, description: @managed_event.description, ends_at: @managed_event.ends_at, host_id: @managed_event.host_id, starts_at: @managed_event.starts_at, title: @managed_event.title, venue_id: @managed_event.venue_id } }
    end

    assert_redirected_to managed_event_url(ManagedEvent.last)
  end

  test "should show managed_event" do
    get managed_event_url(@managed_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_managed_event_url(@managed_event)
    assert_response :success
  end

  test "should update managed_event" do
    patch managed_event_url(@managed_event), params: { managed_event: { category_id: @managed_event.category_id, description: @managed_event.description, ends_at: @managed_event.ends_at, host_id: @managed_event.host_id, starts_at: @managed_event.starts_at, title: @managed_event.title, venue_id: @managed_event.venue_id } }
    assert_redirected_to managed_event_url(@managed_event)
  end

  test "should destroy managed_event" do
    assert_difference("ManagedEvent.count", -1) do
      delete managed_event_url(@managed_event)
    end

    assert_redirected_to managed_events_url
  end
end
