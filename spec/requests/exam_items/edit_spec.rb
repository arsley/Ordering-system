# frozen_string_literal: true

RSpec.describe 'ExamItems GET /exam_items/:id/edit', type: :request, js: true do
  let(:exam_item_id) { ExamItem.all.sample.id }

  include_context :act_login_as_administrator

  before { get edit_exam_item_path(exam_item_id) }

  it 'can show specific inspection detail' do
    expect(assigns[:exam_item]).to eq(ExamItem.find_by(id: exam_item_id))
  end

  it 'can show list of exam sets' do
    expect(assigns[:exam_sets]).to eq(ExamSet.all)
  end

  it { should render_template('edit') }
end
