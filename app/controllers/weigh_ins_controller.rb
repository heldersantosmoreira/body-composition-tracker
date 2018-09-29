class WeighInsController < ApplicationController
  def index
    @weigh_ins = WeighIn.order(when: :desc).page(params[:page]).per(20)
  end

  def upload
    @weigh_in_upload = WeighInUpload.new(params[:data])

    if @weigh_in_upload.save
      flash[:notice] = "#{@weigh_in_upload.records.size} records inserted."
    else
      flash[:warning] = "Couldn't upload records. Is it a valid CSV file?"
    end

    redirect_to weigh_ins_path
  end
end
