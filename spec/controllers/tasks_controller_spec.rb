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
    context "タスクが存在する時" do
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

    context "タスクが存在しない時" do
      subject { -> {get task_path 5} }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe '#new' do
    subject { get new_task_path }

    it "リクエストが成功すること" do
      subject
      expect(response.status).to eq 200
    end
  end

  describe '#edit' do
    let!(:task1) { create(:task1) }
    subject { get edit_task_path task1 }

    it "リクエストが成功すること" do
      subject
      expect(response.status).to eq 200
    end

    it "タスク名が表示されていること" do
      subject
      expect(response.body).to include "task1"
    end

    it "詳細が表示されていること" do
      subject
      expect(response.body).to include "task1です"
    end
  end
end
