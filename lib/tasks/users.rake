# frozen_string_literal: true

namespace :users do
  desc 'seedで登録したユーザーと既存のtasksレコードを紐づけ'

  task add_user_id: :environment do
    task = Task.where(user_id: nil)
    user = User.find(1)
    task.update(user_id:user.id)
  end
end
