# frozen_string_literal: true

RSpec.describe 'ExamItems DELETE /exam_items/:id', type: :request, js: true do
  let(:exam_item_id) { ExamItem.all.sample.id }

  include_context :act_login_as_administrator

  subject { delete exam_item_path(exam_item_id) }

  it 'deletes(discards) exam_item' do
    subject
    expect(ExamItem.with_discarded.find_by(id: exam_item_id).discarded?).to be_truthy
  end

  it 'cannot find by any resource because default_scope is set' do
    subject
    expect(ExamItem.find_by(id: exam_item_id)).to be_nil
  end

  it { is_expected.to redirect_to(exam_items_path) }
end
