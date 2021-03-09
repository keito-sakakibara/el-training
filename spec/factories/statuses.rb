# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    id { 2 }
    name { '着手' }
  end

  trait :todo do
    id { 1 }
    name { '未着手' }
  end

  trait :done do
    id { 3 }
    name { '完了' }
  end
end
