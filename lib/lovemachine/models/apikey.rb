require 'securerandom'

module LoveMachine::Model
  class APIKey < Sequel::Model(:apikey)
    plugin :validation_helpers
    plugin :timestamps

    private

    def before_validation
      set_key
      validates_format /[a-f0-9]{64}/, :key
      super
    end

    def validate
      super
      validates_presence [:key]
    end

    def set_key
      self.key ||= SecureRandom.hex(32)
    end
    
  end
end
