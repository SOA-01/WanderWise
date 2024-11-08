# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'database_helper'

require 'vcr'

describe 'Integration Tests of APIs and Database' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE_FLIGHTS,
                        record: :new_episodes,
                        match_requests_on: %i[method uri body]
  end

  after do
    VCR.eject_cassette
  end

  params = { 'originLocationCode' => 'TPE', 'destinationLocationCode' => 'LAX', 'departureDate' => (Date.today + 7).to_s, 'adults' => '1' }

  describe ', it' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'can fetch flight data from the API and store it in the database' do
      flight = WanderWise::FlightMapper
               .new(WanderWise::AmadeusAPI.new)
               .find_flight(params)[0]

      create_output = WanderWise::Repository::For.entity(flight).create(flight)
      db_record = create_output.values
      date = Date.parse(db_record[:departure_date].to_s)
      formatted_date = date.strftime('%Y-%m-%d')

      #   expect(db_record[:id]).to eq(flight.id)
      expect(db_record[:origin_location_code]).to eq(flight.origin_location_code)
      expect(db_record[:destination_location_code]).to eq(flight.destination_location_code)
      expect(formatted_date).to eq(flight.departure_date)
      expect(db_record[:destination_location_code]).to eq(flight.destination_location_code)
      expect(db_record[:price]).to eq(flight.price)
      expect(db_record[:airline]).to eq(flight.airline)
      expect(db_record[:duration]).to eq(flight.duration)
    end
  end
end
