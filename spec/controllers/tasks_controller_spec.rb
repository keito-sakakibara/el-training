require 'rails_helper'

RSpec.describe TasksController, type: :request do
  describe '#index' do
    subject { get tasks_path }
    it 'リクエストが成功すること' do
      subject
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
  describe '#show' do
    context 'タスクが存在する時' do
      let!(:task1) { create(:task1) }
      subject { get task_path task1.id }

      it 'リクエストが成功すること' do
        subject
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'タスク名が表示されていること' do
        subject
        expect(response.body).to include 'task1'
      end
    end

    context 'タスクが存在しない時' do
      subject { -> { get task_path 5 } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe '#new' do
    subject { get new_task_path }

    it 'リクエストが成功すること' do
      subject
      expect(response.status).to eq 200
    end
  end

  describe '#edit' do
    let!(:task1) { create(:task1) }
    subject { get edit_task_path task1 }

    it 'リクエストが成功すること' do
      subject
      expect(response.status).to eq 200
    end

    it 'タスク名が表示されていること' do
      subject
      expect(response.body).to include 'task1'
    end

    it '詳細が表示されていること' do
      subject
      expect(response.body).to include 'task1です'
    end
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      subject { post tasks_path, params: { task: FactoryBot.attributes_for(:task1) } }

      it 'リクエストが成功すること' do
        subject
        expect(response.status).to eq 302
      end

      it 'タスクが登録される' do
        expect do
          subject
        end.to change(Task, :count).by(1)
      end

      it 'リダイレクトされること' do
        subject
        expect(response).to redirect_to Task.last
      end
    end
  end

  describe "#update" do
    let!(:task1) { FactoryBot.create :task1}

    context "パラメータが妥当な場合" do
      subject { put task_path task1, params: { task1: FactoryBot.attributes_for(:task1) } }

      it "リクエストが成功すること" do
        subject
        expect(response.status).to eq 302
      end

      it "タスク名が更新されること" do
        expect do
          subject
        end.to change { Task.find(task1.id).name }.from("task1").to("task2")
      end
    end
  end

  describe '#destroy' do
    let!(:task1) { FactoryBot.create :task1 }
    subject { delete task_path task1 }

    it 'リクエストが成功すること' do
      subject
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        subject
      end.to change(Task, :count).by(-1)
    end

    it 'タスク一覧にリダイレクトされること' do
      subject
      expect(response).to redirect_to(tasks_path)
    end
  end
end
