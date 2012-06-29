class Admin::ProductDatasheetsController < Admin::BaseController
  def index
    @product_datasheets = collection
  end
  
  def new
    @product_datasheet = ProductDatasheet.new
    render :layout => false
  end
  
  def upload
  end
  
  def edit
  end
  
  def destroy
    @product_datasheet = ProductDatasheet.find(params[:id])
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
  
  def collection
    return @collection if @collection
    
    @search = ProductDatasheet.not_deleted.order('id DESC').metasearch(params[:search])
    @collection = @search.relation.paginate(:per_page => 30, :page => params[:page])
  end
  
  def create
    @product_datasheet = ProductDatasheet.new(params[:product_datasheet])
    @product_datasheet.user = current_user
    
    if @product_datasheet.save && @product_datasheet.xls.original_filename.end_with?(".xls")
      if defined? Delayed::Job
        Delayed::Job.enqueue(@product_datasheet)
      else
        @product_datasheet.perform
      end
      flash.notice = I18n.t("notice_messages.product_datasheet_saved")
      redirect_to admin_product_datasheets_path, :notice => 'Batch updates should soon be get processed.'
    else
      redirect_to admin_product_datasheets_path, :error => 'Couldnt process the product updates. Check your input.'
    end
  end
end
