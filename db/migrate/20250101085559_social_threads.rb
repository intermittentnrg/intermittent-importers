class SocialThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :social_threads, id: :smallserial do |t|
      t.jsonb :reply, null: false, default: {}
    end
  end
end
