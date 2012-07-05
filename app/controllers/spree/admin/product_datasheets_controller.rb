class Spree::Admin::ProductDatasheetsController < Spree::Admin::BaseController
  def index
    @product_datasheets = Spree::ProductDatasheet.not_deleted.page(params[:page] || 1).per(params[:per_page] || 30)
  end
  
  def new
    @product_datasheet = Spree::ProductDatasheet.new
    render :layout => false
  end
  
  def upload
  end
  
  def edit
  end
  
  def destroy
    @product_datasheet = Spree::ProductDatasheet.find(params[:id])
    @product_datasheet.deleted_at = Time.now
    if @product_datasheet.save
      flash.notice = I18n.t("notice_messages.product_datasheet_deleted")
    else
      @product_datasheet.errors.add_to_base('Failed to delete the product datasheet')
    end
    redirect_to admin_product_datasheets_path(:format => :html)
  end
  
  def clone
  end
  
  def create
    @product_datasheet = Spree::ProductDatasheet.new(params[:product_datasheet])
    @product_datasheet.user = current_user
    
    if @product_datasheet.save && @product_datasheet.xls.original_filename.end_with?(".xls")
      if defined? Delayed::Job
        Delayed::Job.enqueue(@product_datasheet, -5)
      else
        @product_datasheet.perform
      end
      flash.notice = I18n.t("notice_messages.product_datasheet_saved")
      redirect_to admin_product_datasheets_path
    else
      @product_datasheets = Spree::ProductDatasheet.not_deleted
      render :template => 'spree/admin/product_datasheets/index', :action => :new
    end
  end
end
