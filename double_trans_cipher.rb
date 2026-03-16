# frozen_string_literal: true

# Implements a deterministic double transposition cipher using a numeric key.
module DoubleTranspositionCipher
  PAD_CHAR = "\0"

  def self.encrypt(document, key)
    text = document.to_s
    return '' if text.empty?

    rows, cols = matrix_dims(text.length)
    row_order, col_order = transposition_orders(rows, cols, key)

    matrix = to_matrix(text, rows, cols)
    matrix = permute_rows(matrix, row_order)
    matrix = permute_columns(matrix, col_order)

    matrix.map(&:join).join
  end

  def self.decrypt(ciphertext, key)
    text = ciphertext.to_s
    return '' if text.empty?

    rows, cols = matrix_dims(text.length)
    row_order, col_order = transposition_orders(rows, cols, key)

    rows_after_encrypt = text.chars.each_slice(cols).map(&:dup)
    rows_with_columns_restored = restore_columns(rows_after_encrypt, col_order, cols)
    original_rows = restore_rows(rows_with_columns_restored, row_order, rows)

    original_rows.join.sub(/\0+\z/, '')
  end

  def self.matrix_dims(length)
    cols = Math.sqrt(length).ceil
    rows = (length.to_f / cols).ceil
    [rows, cols]
  end

  def self.to_matrix(text, rows, cols)
    padded = text.ljust(rows * cols, PAD_CHAR)
    padded.chars.each_slice(cols).map(&:dup)
  end

  def self.transposition_orders(rows, cols, key)
    [permutation(rows, key), permutation(cols, key.to_i + 1)]
  end

  def self.permute_rows(matrix, row_order)
    row_order.map { |idx| matrix[idx] }
  end

  def self.permute_columns(matrix, col_order)
    matrix.map { |row| col_order.map { |idx| row[idx] } }
  end

  def self.restore_columns(rows_after_encrypt, col_order, cols)
    rows_after_encrypt.map do |row|
      restored = Array.new(cols)
      col_order.each_with_index { |original_idx, shuffled_pos| restored[original_idx] = row[shuffled_pos] }
      restored
    end
  end

  def self.restore_rows(rows_with_columns_restored, row_order, rows)
    original_rows = Array.new(rows)
    rows_with_columns_restored.each_with_index do |row, shuffled_pos|
      original_rows[row_order[shuffled_pos]] = row
    end
    original_rows.map(&:join)
  end

  def self.permutation(size, seed)
    (0...size).to_a.shuffle(random: Random.new(seed.to_i))
  end
end
