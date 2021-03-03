# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Status, type: :model do
  context 'パラメータが正常な場合' do
    it 'インスタンスが確保されること' do
      status = build(:status)
      expect(status).to be_valid
    end
  end

  context 'パラメータが不正な場合' do
    it 'nameが空白である場合エラーが表示されること' do
      status = build(:status, name: nil)
      status.valid?
      expect(status.errors[:name]).to include('を入力してください')
    end
  end
end
