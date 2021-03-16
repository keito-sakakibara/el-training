# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'MyString' }
    email { 'MyString' }
    password{ 'password' }
    password_confirmation { 'password' }
  end
end
