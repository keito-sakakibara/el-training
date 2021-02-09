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
    subject { get task_path(task_1.id) }

    let!(:task_1) { create(:task, name: 'name_1', detail: 'detail_1') }
    let!(:task_2) { create(:task, name: 'name_2', detail: 'detail_2') }

    it 'リクエストが成功すること' do
      subject
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it '渡されたIDに紐づくTaskの内容が取得できていること' do
      subject
      expect(response.body).to include(task_1.name)
      expect(response.body).to include(task_1.detail)
    end
  end
end
