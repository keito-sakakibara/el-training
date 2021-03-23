# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /create' do
    let!(:user) { create(:user) }
    subject do
      post login_path,
           params: { session: FactoryBot.attributes_for(:user, email: user.email, password: user.password) }
    end
    it 'ログインが成功すること' do
      subject
      expect(response).to redirect_to root_path
    end

    it 'session[:user_id]とユーザーのidが一致すること' do
      subject
      expect(session[:user_id]).to eq user.id
    end
  end

  describe 'POST /destroy' do
    let!(:user) { create(:user) }
    subject { delete logout_path }
    it 'ログアウトが成功すること' do
      subject
      expect(response).to redirect_to login_path
    end

    it 'session[:user_id]の中身が空であること' do
      subject
      expect(session[:user_id]).to eq nil
    end
  end
end
