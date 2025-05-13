require "application_system_test_case"

class ManagedEventsTest < ApplicationSystemTestCase
  setup do
    @managed_event = managed_events(:one)
  end

  test "visiting the index" do
    visit managed_events_url
    assert_selector "h1", text: "Managed events"
  end

  test "should create managed event" do
    visit managed_events_url
    click_on "New managed event"

    fill_in "Category", with: @managed_event.category_id
    fill_in "Description", with: @managed_event.description
    fill_in "Ends at", with: @managed_event.ends_at
    fill_in "Host", with: @managed_event.host_id
    fill_in "Starts at", with: @managed_event.starts_at
    fill_in "Title", with: @managed_event.title
    fill_in "Venue", with: @managed_event.venue_id
    click_on "Create Managed event"

    assert_text "Managed event was successfully created"
    click_on "Back"
  end

  test "should update Managed event" do
    visit managed_event_url(@managed_event)
    click_on "Edit this managed event", match: :first

    fill_in "Category", with: @managed_event.category_id
    fill_in "Description", with: @managed_event.description
    fill_in "Ends at", with: @managed_event.ends_at.to_s
    fill_in "Host", with: @managed_event.host_id
    fill_in "Starts at", with: @managed_event.starts_at.to_s
    fill_in "Title", with: @managed_event.title
    fill_in "Venue", with: @managed_event.venue_id
    click_on "Update Managed event"

    assert_text "Managed event was successfully updated"
    click_on "Back"
  end

  test "should destroy Managed event" do
    visit managed_event_url(@managed_event)
    click_on "Destroy this managed event", match: :first

    assert_text "Managed event was successfully destroyed"
  end
end
