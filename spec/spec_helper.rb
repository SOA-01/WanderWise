# frozen_string_literal: true

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

ENV['RACK_ENV'] = 'test'

curr_dir = __dir__
CORRECT_NYT = YAML.load_file("#{curr_dir}/fixtures/nytimes-results.yml")
CORRECT_FLIGHTS = YAML.load_file("#{curr_dir}/fixtures/flight-offers-results.yml")
CONFIG = YAML.load_file('config/secrets.yml')

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE_NYT = 'nyt_api'
CASSETTE_FILE_FLIGHTS = 'flights_api'

AMADEUS_API_CLIENT_ID = CONFIG['test']['amadeus_client_id']
AMADEUS_API_CLIENT_SECRET = CONFIG['test']['amadeus_client_secret']
NYTIMES_API_KEY = CONFIG['test']['nytimes_api_key']

ONE_WEEK_FROM_NOW = (Date.today + 7).to_s
