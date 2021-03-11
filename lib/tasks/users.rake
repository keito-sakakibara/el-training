# frozen_string_literal: true

namespace :users do
  desc '初期ユーザーの登録'
  task create_user: :environment do
    User.create(name: 'test_name', email: 'test@test.com')
  end
end
