
Sequel.migration do
  up do
    
    # TODO: Couldn't get the namespace issues worked out. This doesn't belong here.
    db = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/lovemachine')

    db.run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
 
    db.run(<<-STR)
      CREATE TABLE users(
        id         UUID PRIMARY KEY DEFAULT UUID_GENERATE_V4(),
        email      TEXT NOT NULL UNIQUE,
        created_at TIMESTAMPTZ DEFAULT NOW()
      )
    STR

    db.run(<<-STR)
      CREATE TABLE love(
        id         UUID PRIMARY KEY DEFAULT UUID_GENERATE_V4(),
        to_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        from_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        message    TEXT NOT NULL,
        created_at TIMESTAMPTZ DEFAULT NOW()
      )
    STR

    db.run(<<-STR)
      CREATE TABLE apikey(
        id         UUID PRIMARY KEY DEFAULT UUID_GENERATE_V4(),
        key        TEXT NOT NULL UNIQUE,
        created_at TIMESTAMPTZ DEFAULT NOW()
      )
    STR


    db.run(<<-STR)
      CREATE INDEX users_email_idx ON users(email)
    STR
  end

  down do
    drop_table(:love)
  end
end
