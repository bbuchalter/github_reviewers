#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require_relative '../lib/github_reviewers/github_reviewers'
OCTOKIT_SILENT = true

GitHubReviewers.new(
  org: ARGV[0],
  author: ARGV[1],
  since: ARGV[2],
  token: ARGV[3] || ENV['GITHUB_TOKEN']
).print_summary
