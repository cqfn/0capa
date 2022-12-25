require "test_helper"

class Api::Export::V1::RepoStatsControllerTest < ActionDispatch::IntegrationTest
  test "should get repo_stats" do
    get api_export_v1_repo_stats_repo_stats_url
    assert_response :success
  end
end
