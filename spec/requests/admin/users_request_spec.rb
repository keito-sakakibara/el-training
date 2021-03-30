# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let!(:admin) { create(:user, :admin) }
  before do
    post login_path,
         params: { session: FactoryBot.attributes_for(:user, :admin, email: admin.email, password: admin.password,
                                                                     is_admin: admin.is_admin) }
  end

  describe '#index' do
    context '管理者でログインしている場合' do
      subject { get admin_users_path }

      it 'リクエストが成功すること' do
        subject
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
    context '一般ユーザーでログインしている場合' do
      let(:user) { create(:user) }
      before do
        post login_path,
             params: { session: FactoryBot.attributes_for(:user, email: user.email, password: user.password,
                                                                 is_admin: user.is_admin) }
      end
      subject { get admin_users_path }

      it 'ルートパスにリダイレクトされること' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#show' do
    context 'ユーザーが存在している場合' do
      subject { get admin_user_path admin.id }

      it 'リクエストが成功すること' do
        subject
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'ユーザー名が表示されていること' do
        subject
        expect(response.body).to include 'admin'
      end

      it 'メールアドレスが表示されていること' do
        subject
        expect(response.body).to include 'admin@admin.com'
      end
    end

    context 'ユーザーが存在しない場合' do
      subject { -> { get admin_user_path 5 } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe '#new' do
    subject { get new_admin_user_path }

    it 'リクエストが成功すること' do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    subject { get edit_admin_user_path admin }

    it 'リクエストが成功すること' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'ユーザー名が表示されていること' do
      subject
      expect(response.body).to include 'admin'
    end

    it 'メールアドレスが表示されていること' do
      subject
      expect(response.body).to include 'admin@admin.com'
    end
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      subject do
        post admin_users_path, params: { user: FactoryBot.attributes_for(:user, :admin) }
      end

      it 'ユーザーが登録されること' do
        expect do
          subject
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトされること' do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to admin_user_path User.last.id
      end
    end

    context 'パラメータが不正な場合' do
      subject do
        post admin_users_path, params: { user: FactoryBot.attributes_for(:user, :admin, name: nil) }
      end

      it 'ユーザーが登録されないこと' do
        expect do
          subject
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        subject
        expect(response.body).to include 'ユーザーの作成に失敗しました'
      end
    end
  end

  describe '#update' do
    context 'パラメータが妥当な場合' do
      subject do
        put admin_user_path admin,
                            params: { user: FactoryBot.attributes_for(:user, :admin, name: 'admin2',
                                                                                     email: 'admin2@admin.com', is_admin: false) }
      end

      it 'ユーザー名が更新されること' do
        expect do
          subject
        end.to change { User.find(admin.id).name }.from('admin').to('admin2')
      end

      it 'メールアドレスが更新されること' do
        expect do
          subject
        end.to change { User.find(admin.id).email }.from('admin@admin.com').to('admin2@admin.com')
      end

      it 'メールアドレスが更新されること' do
        expect do
          subject
        end.to change { User.find(admin.id).is_admin }.from(true).to(false)
      end

      it 'リダイレクトされること' do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to admin_users_path User.last.id
      end
    end

    context 'パラメータが不正な場合' do
      subject do
        put admin_user_path admin,
                            params: { user: FactoryBot.attributes_for(:user, :admin, name: nil, email: nil,
                                                                                     is_admin: nil) }
      end

      it 'ユーザー名が変更されないこと' do
        expect do
          subject
        end.to_not change(User.find(admin.id), :name)
      end

      it 'メールアドレスが変更されないこと' do
        expect do
          subject
        end.to_not change(User.find(admin.id), :email)
      end

      it '管理者権限が変更されないこと' do
        expect do
          subject
        end.to_not change(User.find(admin.id), :is_admin)
      end

      it 'エラーが表示されること' do
        subject
        expect(response.body).to include 'ユーザーの編集に失敗しました'
      end
    end
  end

  describe '#destroy' do
    context '管理者が2人以上いる場合' do
      let!(:admin2) { create(:user, :admin) }
      subject { delete admin_user_path admin }

      it 'ユーザーが削除されること' do
        expect do
          subject
        end.to change(User, :count).by(-1)
      end

      it 'リダイレクトされること' do
        subject
        expect(response).to redirect_to admin_users_path
      end
    end

    context '管理者が1人しかいない場合' do
      subject { delete admin_user_path admin }

      it 'ユーザーが削除されないこと' do
        expect do
          subject
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        subject
        expect(response.body).to include '管理者は最低1人必要です'
      end
    end
  end
end
