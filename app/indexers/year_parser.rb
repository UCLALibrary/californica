# frozen_string_literal: true

class YearParser
  # @param dates [String, Array<String>] A list of String dates
  # @return [Array<Integer>] Sorted list of years that correspond to those dates
  def self.integer_years(dates)
    Array.wrap(dates).map do |date|
      if has_a_year?(date)
        Date.strptime(date, '%Y').year
      end
    end.compact.sort
  end

  # If this string doesn't have 4 numbers in a row, it doesn't contain a 4-digit year.
  def self.has_a_year?(input_string)
    four_digit_year = %r{\d{4}}
    input_string.match?(four_digit_year)
  end
end
