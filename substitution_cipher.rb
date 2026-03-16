# frozen_string_literal: true

module SubstitutionCipher
  # Caesar substitution cipher implementation.
  module Caesar
    # Encrypts document using key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      document.to_s.each_char.map { |ch| (ch.ord + key).chr }.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      document.to_s.each_char.map { |ch| (ch.ord - key).chr }.join
    end
  end

  # Keyed permutation substitution cipher implementation.
  module Permutation
    # Encrypts document using key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      shuffled = (0..127).to_a.shuffle(random: Random.new(key))
      document.to_s.each_char.map { |ch| shuffled[ch.ord].chr }.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      shuffled = (0..127).to_a.shuffle(random: Random.new(key))
      reverse_lookup = {}
      shuffled.each_with_index { |mapped_ord, original_ord| reverse_lookup[mapped_ord] = original_ord }

      document.to_s.each_char.map { |ch| reverse_lookup[ch.ord].chr }.join
    end
  end
end
