# frozen_string_literal: true

require 'http'
require 'yaml'
require 'json'
require 'date'
require_relative '../entities/nytimes_entity'

module WanderWise
  # Gateway to NY Times API for recent articles
  class NYTimesAPI
    def initialize
      @secrets = YAML.load_file('./config/secrets.yml')
      @api_key = @secrets['nytimes_api_key']
    end

    # Fetch recent articles based on the keyword
    def fetch_recent_articles(keyword)
      today = DateTime.now
      one_week_ago = (today - 7).strftime('%Y%m%d')
      base_url = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'

      params = {
        'q' => keyword,
        'begin_date' => one_week_ago,
        'end_date' => today.strftime('%Y%m%d'),
        'api-key' => @api_key
      }

      # Return raw parsed JSON as a Ruby hash
      self.class.fetch_articles(base_url, params)
    end

    # Perform the API call and return the JSON response as a Ruby hash
    def self.fetch_articles(base_url, params)
      response = HTTP.get(base_url, params:)
      response_body = response.body.to_s.force_encoding('UTF-8')
      JSON.parse(response_body)
    end
  end
end
