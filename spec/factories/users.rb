# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
    is_admin { false }
  end
  trait :admin do
    name { 'admin' }
    email { 'admin@admin.com' }
    password { 'admin' }
    password_confirmation { 'admin' }
    is_admin { true }
  end
end
