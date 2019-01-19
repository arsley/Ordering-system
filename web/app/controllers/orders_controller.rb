# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_patient, only: %i[index new create]
  before_action :set_for_new, only: %i[new create]

  def index
    @orders = @patient.orders.where(canceled: false)
  end

  def new; end

  def create
    if create_params[:inspections].nil?
      flash.now[:warning] = '検査項目は必ず指定してください。'
      render :new, status: :bad_request
      return
    end

    @order = @patient.orders.create!(may_result_at: create_params[:may_result_at])
    CreateInspectionService.call(order: @order, inspections: create_params[:inspections])

    flash[:success] = "オーダー##{@order.id}を作成しました。"
    CreateLogService.call(log_type: :order_created, resource: @order, employee: current_employee)
    CreateNotificationService.call(
      contents: {
        'en' => "Created Order##{@order.id} to Patient #{@order.patient.name}.",
        'ja' => "患者#{@order.patient.name}にオーダー##{@order.id}が作成されました。"
      },
      type: '新規オーダー作成'
    )
    redirect_to order_inspections_path(@order)
  end

  def edit
    @order = Order.find_by(id: params[:id])
  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.update!(update_params)

    flash[:success] = '更新しました。'
    CreateLogService.call(log_type: :order_updated, resource: @order, employee: current_employee)
    CreateNotificationService.call(
      contents: {
        'en' => "#{@order.canceled? ? 'Canceled' : 'Re-reserved'} Order##{@order.id}.",
        'ja' => "オーダー##{@order.id}が#{@order.canceled? ? 'キャンセル' : '再予約'}されました。"
      },
      type: 'オーダー情報更新'
    )
    redirect_to patient_orders_path(@order.patient)
  end

  # do not destroy(delete)
  def destroy; end

  private

  # if no inspections selected, must re-render 'new'
  # and set @order and @details
  # because `render` doesn't call as action(same request)
  def set_for_new
    @order = @patient.orders.new
    @sets  = InspectionSet.all
    @details = InspectionDetail.all
  end

  def set_patient
    @patient = Patient.find_by(id: params[:patient_id])
  end

  def create_params
    params.require(:order).permit(:may_result_at, inspections: [])
  end

  def update_params
    params.require(:order).permit(:canceled)
  end
end
