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
      let!(:task) { create(:task) }
      subject { get task_path task.id }

      it 'リクエストが成功すること' do
        subject
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'タスク名が表示されていること' do
        subject
        expect(response.body).to include 'task'
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
    let!(:task) { create(:task) }
    subject { get edit_task_path task }

    it 'リクエストが成功すること' do
      subject
      expect(response.status).to eq 200
    end

    it 'タスク名が表示されていること' do
      subject
      expect(response.body).to include 'name'
    end

    it '詳細が表示されていること' do
      subject
      expect(response.body).to include 'detail'
    end
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      subject { post tasks_path, params: { task: FactoryBot.attributes_for(:task) } }

      it 'タスクが登録される' do
        expect do
          subject
        end.to change(Task, :count).by(1)
      end

      it 'リダイレクトされること' do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to Task.last
      end
    end
  end

  describe "#update" do
    let!(:task) { create(:task) }

    context "パラメータが妥当な場合" do
      subject { put task_path task, params: { task: FactoryBot.attributes_for(:task,name:"sample",detail:"sample_detail") } }

      it "タスク名が更新されること" do
        expect do
          subject
        end.to change { Task.find(task.id).name }.from("name").to("sample")
      end

      it "リダイレクトすること" do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to Task.last
      end
    end
  end

  describe '#destroy' do
    let!(:task) { FactoryBot.create :task }
    subject { delete task_path task }

    it 'タスクが削除されること' do
      expect do
        subject
      end.to change(Task, :count).by(-1)
    end

    it 'タスク一覧にリダイレクトされること' do
      subject
      expect(response.status).to eq 302
      expect(response).to redirect_to(tasks_path)
    end
  end
end
