
module LoveMachine::Model
  class Love < Sequel::Model(:love)
    many_to_one :user
  end
end

