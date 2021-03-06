# frozen_string_literal: true

class ExamSetsController < ApplicationController
  before_action :set_exam_datas, only: %i[new create edit update]

  def index
    @exam_sets = ExamSet.page(params[:page])
  end

  def new
    @exam_set = ExamSet.new
  end

  def create
    @exam_set = ExamSet.new(exam_set_params)
    if @exam_set.save
      flash[:success] = "検査セット #{@exam_set.name} を作成しました。"
      redirect_to exam_sets_path
    else
      render :new, status: :bad_request
    end
  end

  def edit
    @exam_set = ExamSet.find_by(id: params[:id])
  end

  def update
    @exam_set = ExamSet.find_by(id: params[:id])
    if @exam_set.update(exam_set_params)
      redirect_to exam_set_path(@exam_set)
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    exam_set = ExamSet.find_by(id: params[:id])
    exam_set.paper_trail_event = 'discard'
    exam_set.discard
    flash[:success] = '検査セット情報を削除しました。'
    redirect_to exam_sets_path
  end

  private

  def exam_set_params
    params
      .require(:exam_set)
      .permit(:name, exam_item_ids: [])
  end

  def set_exam_datas
    @exam_items = ExamItem.all
    @exam_sets  = ExamSet.all
  end
end
