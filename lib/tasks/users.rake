# frozen_string_literal: true

namespace :users do
  desc 'seedで登録したユーザーと既存のtasksレコードを紐づけ'

  task add_user_id: :environment do
    tasks = Task.where(status_id: nil, priority_id: nil, user_id: nil)
    status = Status.find_by!(name: '着手')
    priority = Priority.find_by!(name: '高')
    user = User.find_by!(name: 'テストユーザー', email: 'test@test.com')
    tasks.each do |task|
      task.update!(status_id: status.id, priority_id: priority.id, user_id: user.id)
    end
  rescue StandardError => e
    Rails.logger.error(e)
  end

  desc 'seedデータにパスワード追加'

  task add_password: :environment do
    user = User.find_by(name: 'テストユーザー', email: 'test@test.com')
    user.update(password: 'password', password_confirmation: 'password')
  end
end
