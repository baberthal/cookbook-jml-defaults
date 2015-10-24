module JMLDefaultsCookbook
  module Helpers
    class InvalidPasswordError < StandardError; end
    def self.included(_)
      require 'securerandom' unless defined?(SecureRandom)
      require 'digest/sha2' unless defined?(Digest)
    end

    def encrypt_password(password, hash_algo = :sha512)
      build_password(password, hash_algo).tap do |pw|
        fail InvalidPasswordError unless UnixCrypt.valid?(password, pw)
      end
    end

    def build_password(password, hash_algo = :sha512)
      hashing_alogrithm = lookup_hash_algo(hash_algo)
      hashing_alogrithm.build(password)
    end

    private

    def lookup_hash_algo(hash_algo)
      UnixCrypt.const_get(hash_algo.upcase)
    end
  end
end
