# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'パラメータが正常な場合' do
    it 'インスタンスが確保されること' do
      task = build(:task)
      expect(task).to be_valid
    end
  end

  context 'パラメータが不正な場合' do
    it 'nameが空白である場合エラーが表示されること' do
      task = build(:task, name: nil)
      task.valid?
      expect(task.errors[:name]).to include('を入力してください')
    end
  end
end
