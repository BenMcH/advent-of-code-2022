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
        puts "Requesting"
        res = Net::HTTP.get_response(URI("https://adventofcode.com/#{year}/day/#{day}/input"), {Cookie: "session=#{session}", "User-Agent" => "Ben McHone <ben@mchone.dev>"})
        body = res.body

        if body.strip == "Please don't repeatedly request this endpoint before it unlocks! The calendar countdown is synchronized with the server time; the link will be enabled on the calendar the instant this puzzle becomes available."
          throw Error.new("Puzzle input not open")
        end

        File.write('./input', res.body)

        res.body
      end
    end
  end
end
