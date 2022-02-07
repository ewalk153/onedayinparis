require "application_system_test_case"

class MetroStationsTest < ApplicationSystemTestCase
  setup do
    @metro_station = metro_stations(:one)
  end

  test "visiting the index" do
    visit metro_stations_url
    assert_selector "h1", text: "Metro stations"
  end

  test "should create metro station" do
    visit metro_stations_url
    click_on "New metro station"

    fill_in "Name", with: @metro_station.name
    fill_in "Node", with: @metro_station.node_id
    fill_in "X", with: @metro_station.x
    fill_in "Y", with: @metro_station.y
    click_on "Create Metro station"

    assert_text "Metro station was successfully created"
    click_on "Back"
  end

  test "should update Metro station" do
    visit metro_station_url(@metro_station)
    click_on "Edit this metro station", match: :first

    fill_in "Name", with: @metro_station.name
    fill_in "Node", with: @metro_station.node_id
    fill_in "X", with: @metro_station.x
    fill_in "Y", with: @metro_station.y
    click_on "Update Metro station"

    assert_text "Metro station was successfully updated"
    click_on "Back"
  end

  test "should destroy Metro station" do
    visit metro_station_url(@metro_station)
    click_on "Destroy this metro station", match: :first

    assert_text "Metro station was successfully destroyed"
  end
end
