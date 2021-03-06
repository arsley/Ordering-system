# frozen_string_literal: true

class ExamSet < ApplicationRecord
  # implement soft delete
  include Discard::Model
  default_scope -> { kept.order(:id) }

  has_paper_trail

  # Declare relation
  has_and_belongs_to_many :exam_items, join_table: 'combinations'

  # Declare validation
  validates :name, presence: true
end
