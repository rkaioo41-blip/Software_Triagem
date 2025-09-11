require "test_helper"

class TriagensControllerTest < ActionDispatch::IntegrationTest
  test "should get criar" do
    get triagens_criar_url
    assert_response :success
  end

  test "should get mostrar" do
    get triagens_mostrar_url
    assert_response :success
  end

  test "should get salvar_passo" do
    get triagens_salvar_passo_url
    assert_response :success
  end
end
