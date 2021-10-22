require "test_helper"

class Api::V1::WebhookControllersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/api/v1/webhook", as: :json
    assert_response :success
  end

  test "should activate the radar via webhook" do
    post "/api/v1/webhook?source=github", params: {
                                            "agentname": "GitHub Agent",
                                            "accesstokenendpoint": "https://github.com/login/oauth/access_token",
                                            "authorizationbaseurl": "https://github.com/login/oauth/authorize",
                                            "requesttokenendpoint": "",
                                            "authenticationmethod": "OAuth20",
                                            "apikey": "",
                                            "apisecret": "",
                                            "repository": {
                                              "full_name": "test",
                                            },
                                          }, as: :json
    assert_response 201
  end

  test "should activate a not implemented radar via webhook " do
    post "/api/v1/webhook?source=trello-test", params: {
                                                 "agentname": "GitHub Agent",
                                                 "accesstokenendpoint": "https://github.com/login/oauth/access_token",
                                                 "authorizationbaseurl": "https://github.com/login/oauth/authorize",
                                                 "requesttokenendpoint": "",
                                                 "authenticationmethod": "OAuth20",
                                                 "apikey": "",
                                                 "apisecret": "",
                                                 "repository": {
                                                   "full_name": "test",
                                                 },
                                               }, as: :json

    assert_response 422
  end

  test "should not delete the activation history" do
    delete "/api/v1/webhook/1", params: { testing: false }, as: :json

    assert_response 403
  end

  test "deleting test cases" do
    delete "/api/v1/webhook/1", params: { testing: true }, as: :json

    assert_response 204
  end
end
