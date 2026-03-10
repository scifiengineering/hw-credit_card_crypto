# frozen_string_literal: true

# The LuhnValidator module provides a method to validate credit card numbers using the Luhn algorithm.
module LuhnValidator
  # Validates credit card number using Luhn Algorithm
  # arguments: none
  # assumes: a local String called 'number' exists
  # returns: true/false whether last digit is correct
  def validate_checksum
    nums_a = number.to_s.chars.map(&:to_i)

    # Double every second digit from right (excluding check digit)
    sum = nums_a.reverse.each_with_index.sum do |digit, index|
      if index.odd?
        doubled = digit * 2
        doubled > 9 ? doubled - 9 : doubled
      else
        digit
      end
    end

    (sum % 10).zero?
  end
end
