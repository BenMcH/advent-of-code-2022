# frozen_string_literal: true
require 'net/http'
require_relative "helpers/version"

module Aoc
  module Helpers
    class Error < StandardError; end

    def self.get_input(year, day, session)
      input = if File.exists?('./input')
        File.read('./input')
      else
        p "Requesting"
        res = Net::HTTP.get_response(URI("https://adventofcode.com/#{year}/day/#{day}/input"), {Cookie: "session=#{session}", "User-Agent" => "Ben McHone <ben@mchone.dev>"})

        File.write('./input', res.body)

        res.body
      end
    end
  end
end
