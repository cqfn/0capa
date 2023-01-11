# frozen_string_literal: true

require 'test_helper'

module Api
  module Export
    module V1
      class RepoStatsControllerTest < ActionDispatch::IntegrationTest
        test 'should get repo_stats' do
          get api_export_v1_repo_stats_repo_stats_url
          assert_response :success
        end
      end
    end
  end
end
