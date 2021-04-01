FactoryBot.define do
  factory :task_label_relationship do
    association :label
    association :task
  end
end
