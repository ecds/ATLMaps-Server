# frozen_string_literal: true

#
# Custom serializer for JSONB objects stored in
# the database
#
class HashSerializer
  #
  # Dump hash to JSON
  #
  # @param [Hash] hash to be dumped to JSON
  #
  # @return [JSON] JSON of Hash
  #
  def self.dump(hash)
    hash.to_json
  end

  #
  # Implements a hash where keys :foo and "foo" are considered to be the same.
  #
  # @param [Hash] hash
  #
  # @return [Hash]
  #
  def self.load(hash)
    hash = JSON.parse(hash) if hash.is_a? String
    (hash || {}).with_indifferent_access
  end
end
