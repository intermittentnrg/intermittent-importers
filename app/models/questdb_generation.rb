class QuestdbGeneration < ActiveRecord::Base
  establish_connection :questdb
end
