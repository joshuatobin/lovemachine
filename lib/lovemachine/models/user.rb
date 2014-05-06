
module LoveMachine::Model
  class User < Sequel::Model
    one_to_many :love
  end
end
