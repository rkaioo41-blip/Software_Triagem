require "test_helper"

class Api::PacienteFakesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_paciente_fakes_index_url
    assert_response :success
  end

  test "should get show" do
    get api_paciente_fakes_show_url
    assert_response :success
  end
end
