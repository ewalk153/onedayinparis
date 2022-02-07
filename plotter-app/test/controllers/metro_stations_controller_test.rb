require "test_helper"

class MetroStationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metro_station = metro_stations(:one)
  end

  test "should get index" do
    get metro_stations_url
    assert_response :success
  end

  test "should get new" do
    get new_metro_station_url
    assert_response :success
  end

  test "should create metro_station" do
    assert_difference("MetroStation.count") do
      post metro_stations_url, params: { metro_station: { name: @metro_station.name, node_id: @metro_station.node_id, x: @metro_station.x, y: @metro_station.y } }
    end

    assert_redirected_to metro_station_url(MetroStation.last)
  end

  test "should show metro_station" do
    get metro_station_url(@metro_station)
    assert_response :success
  end

  test "should get edit" do
    get edit_metro_station_url(@metro_station)
    assert_response :success
  end

  test "should update metro_station" do
    patch metro_station_url(@metro_station), params: { metro_station: { name: @metro_station.name, node_id: @metro_station.node_id, x: @metro_station.x, y: @metro_station.y } }
    assert_redirected_to metro_station_url(@metro_station)
  end

  test "should destroy metro_station" do
    assert_difference("MetroStation.count", -1) do
      delete metro_station_url(@metro_station)
    end

    assert_redirected_to metro_stations_url
  end
end
