require 'rails_helper'

RSpec.describe Task, type: :model do
  it "成功" do
    task = build(:task)
    expect(task).to be_valid
  end

  it "成功" do
    task = build(:task, name:nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end
end