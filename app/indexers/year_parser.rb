# frozen_string_literal: true

class YearParser
  # @param dates [String, Array<String>] A list of String dates
  # @return [Array<Integer>] Sorted list of years that correspond to those dates
  def self.integer_years(dates)
    Array.wrap(dates).flat_map do |date|
      years(date) if maybe_contains_a_year?(date)
    end.compact.uniq.sort
  end

  # If this string doesn't have 4 numbers in a row, it doesn't contain a 4-digit year.
  def self.maybe_contains_a_year?(input_string)
    four_digit_year = %r{\d{4}}
    input_string.match?(four_digit_year)
  end

  def self.years(input_string)
    if date_range?(input_string)
      expand_date(input_string)
    else
      parse_year(input_string)
    end
  end

  # Check if it's meant to be a range of dates instead of a single date. Examples:
  #   '1937/1939'
  #   '1934-06/1934-07'
  def self.date_range?(input_string)
    input_string.match?(range_separator)
  end

  def self.range_separator
    %r{\/} # a forward slash
  end

  # If the string is a range of dates instead of a
  # single date, expand the range into an array of
  # values.
  def self.expand_date(input_string)
    range_start = input_string.match(/^(.*)#{range_separator}/).captures.first
    range_end = input_string.match(/^.*#{range_separator}(.*)/).captures.first

    starting_year = parse_year(range_start)
    ending_year = parse_year(range_end)

    (starting_year..ending_year).to_a
  end

  def self.parse_year(date_string)
    Date.strptime(date_string, '%Y').year
  end
end
