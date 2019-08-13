# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Employees POST /employees', type: :request, js: true do
  # WARNING: 稀に Faker::Internet.username で生成した擬似ユーザー名が衝突する場合があります
  let!(:administor) { create(:administor) }
  let!(:employees) { create_list(:employee, 5) }
  let(:employee) { employees.first }
  let(:employee_id) { employee.id }

  # 全てのアクションにおいてログインが必要です
  before { post login_path, params: { username: administor.username, password: administor.password } }

  context 'when request is valid' do
    let(:valid_params) do
      {
        employee: {
          fullname: 'Dr. Blah',
          username: 'blah',
          password: 'passworld',
          password_confirmation: 'passworld'
        }
      }
    end
    before { post employees_path, params: valid_params }

    it 'creates new employee' do
      expect(Employee.last).to eq(assigns[:employee])
    end

    it { should redirect_to(employee_path(Employee.last.id)) }
  end

  context 'when request is invalid' do
    let(:invalid_params) do
      {
        employee: {
          fullname: '',
          username: '',
          password: '',
          password_confirmation: ''
        }
      }
    end
    before { post employees_path, params: invalid_params }

    it { should render_template('new') }
  end
end
