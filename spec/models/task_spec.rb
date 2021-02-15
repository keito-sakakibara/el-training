require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'インスタンスが確保されること' do
    task = build(:task)
    expect(task).to be_valid
  end

  it 'nameが空白である場合エラーが表示されること' do
    task = build(:task, name: nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end
end
