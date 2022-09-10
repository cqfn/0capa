# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TomSetting.create(
  agentname: 'github',
  apisecret: '',
  isactive: 'Y',
  created_at: Time.now,
  updated_at: Time.now,
  invitations_endpoint: 'https://api.github.com/user/repository_invitations',
  invitations_accept_endpoint: 'https://api.github.com/user/repository_invitations/#invitation_id',
  content_type: 'application/vnd.github.v3+json',
  repos_info_url: 'https://api.github.com/repos/#repo_fullname',
  repos_diff_url: 'https://api.github.com/repos/#repo_fullname/compare/#base_commit_id...#head_commit_id',
  commits_info_url: 'https://api.github.com/repos/#repo_fullname/commits',
  contributors_info_url: 'https://api.github.com/repos/#repo_fullname/stats/contributors',
  forks_info_url: 'https://api.github.com/repos/#repo_fullname/forks',
  issues_info_url: 'https://api.github.com/repos/#repo_fullname/issues',
  pulls_info_url: 'https://api.github.com/repos/#repo_fullname/pulls',
  releases_info_url: 'https://api.github.com/repos/#repo_fullname/releases',
  stars_info_url: 'https://api.github.com/repos/#repo_fullname/stargazers',
  workflows_info_url: 'https://api.github.com/repos/#repo_fullname/actions/runs',
  issues_Comments_info_url: 'https://api.github.com/repos/#repo_fullname/issues/comments',
  node_name: ''
)
