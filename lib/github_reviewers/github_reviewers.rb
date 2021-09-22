# frozen_string_literal: true

require 'octokit'

# Prints a summary of who reviewed PRs for a specific PR author over a given period of time.
class GitHubReviewers
  def initialize(org:, author:, since:, token: ENV['GITHUB_TOKEN'])
    @author = author
    @since = since
    @org = org
    @token = token
    @author_summary = Hash.new do |summary, reviewer|
      summary[reviewer] = Hash.new do |author_summary, review_state|
        author_summary[review_state] = 0
      end
    end
  end

  # Interesting note: can't use attr_reader for author_summary for some reason
  attr_reader :author, :since, :org, :token

  def print_summary
    collect_author_summary_data
    pp @author_summary
  end

  private

  def collect_author_summary_data
    prs = prs_for_author
    print 'Collecting data about reviewers for PRs'
    prs.each_with_object({}) do |pr, author_summary|
      repo = pr.repository_url.split('/').last(2).join('/')
      who_reviewed(repo, pr.number).each do |reviewer, state|
        print '.'

        @author_summary[reviewer][state] += 1
      end
    end
    puts "done."
  end

  def prs_for_author
    puts "Searching for PRs with the following criteria: #{pr_search_query}"
    search_results = with_auto_pagination { client.search_issues(pr_search_query) }
    raise unless search_results.total_count == search_results.items.length # guard that we got all the results

    puts "Found #{search_results.total_count} PRs."
    search_results.items
  end

  def client
    @client ||= Octokit::Client.new(access_token: @token)
  end

  def who_reviewed(repo, pull_request_number)
    reviews = client.pull_request_reviews(repo, pull_request_number)
    reviews.map { |review| [review.user.login, review.state] unless review.user.login == author }.compact
  end

  def pr_search_query
    "is:pull-request org:#{org} author:#{author} created:>#{since}"
  end

  def with_auto_pagination
    previous_auto_paginate_setting = client.auto_paginate
    client.auto_paginate = true
    result = yield
    client.auto_paginate = previous_auto_paginate_setting
    result
  end
end
