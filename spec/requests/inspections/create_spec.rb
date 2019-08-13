# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Inspections POST /orders/:order_id/inspections', type: :request, js: true do
  let(:employee) { create(:employee) }
  let(:patient) { create(:patient) }
  let(:order) { patient.orders.first }
  let(:inspection) { order.inspections.first }

  # 全てのアクションにおいてログインが必要です
  before { post login_path, params: { username: employee.username, password: employee.password } }

  context 'when the request is valid' do
    let(:valid_params) do
      { order: { inspections: (1..10).to_a } }
    end
    before { post order_inspections_path(order.id), params: valid_params }

    it 'creates a order' do
      expect(Order.last).to eq(assigns[:order])
    end

    it { should redirect_to(order_inspections_path(Order.last)) }
  end

  context 'when no inspections selected' do
    let(:invalid_params) do
      { order: { inspections: [] } }
    end
    before { post order_inspections_path(order.id), params: invalid_params }

    it { should render_template('new') }

    it 'returns status code 400(Bad request)' do
      expect(response).to have_http_status(400)
    end
  end
end
