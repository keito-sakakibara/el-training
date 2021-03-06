# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'name' }
    detail { 'detail' }
    deadline_date { '2021-02-18' }
    association :status
    association :priority
    association :user
  end
end
