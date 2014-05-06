module LoveMachine
  module Config
    extend self

    def env(key)
      ENV[key]
    end

    def env!(key)
      ENV[key] or raise "Missing ENV[#{key}]"
    end

    def database_url
      env("DATABASE_URL") || 'postgres://localhost/lovemachine'
    end

  end
end
