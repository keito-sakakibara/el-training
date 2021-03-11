# frozen_string_literal: true

FactoryBot.define do
  factory :priority do
    id { 1 }
    name { '高' }
  end

  trait :medium do
    id { 2 }
    name { '中' }
  end

  trait :low do
    id { 3 }
    name { '低' }
  end
end
