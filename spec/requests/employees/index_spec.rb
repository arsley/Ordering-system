# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Employees GET /employees', type: :request, js: true do
  # WARNING: it rarely generates duplicated username by Faker::Internet.username
  let!(:administor) { create(:administor) }
  let!(:employees) { create_list(:employee, 5) }
  let(:employee) { employees.first }
  let(:employee_id) { employee.id }

  # all actions are requied logged in
  before { post login_path, params: { username: administor.username, password: administor.password } }

  before { get employees_path }

  it 'can show all employees' do
    expect(Employee.all).to eq(assigns[:employees])
  end
end
