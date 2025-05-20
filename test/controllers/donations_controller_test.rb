require "test_helper"

class DonationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get donations_index_url
    assert_response :success
  end

  test "should get create" do
    get donations_create_url
    assert_response :success
  end

  test "should get update" do
    get donations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get donations_destroy_url
    assert_response :success
  end
end
