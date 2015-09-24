require 'rake'
Rake::Task.clear
Jordyblue::Application.load_tasks
# load File.join(Rails.root, 'lib', 'tasks', 'spree_batch_products_extension_tasks.rake')

class Spree::Admin::ProductDatasheetsController < Spree::Admin::ResourceController
  def index
    @product_datasheets = Spree::ProductDatasheet.
                              not_deleted.
                              order('id DESC').
                              page(params[:page] || 1).
                              per(params[:per_page] || 30)
  end

  def download
    if params[:type] == 'variants'
      Rake::Task['spree_batch:variants_backup'].invoke
    else
      Rake::Task['spree_batch:products_backup'].invoke
    end
    render 'download'
  end

  def upload
  end

  def edit
  end

  def destroy
    @product_datasheet = Spree::ProductDatasheet.find(params[:id])
    @product_datasheet.deleted_at = Time.now

    if @product_datasheet.save
      flash[:success] = Spree.t("notice_messages.product_datasheet_deleted")
    else
      @product_datasheet.errors.add_to_base('Failed to delete the product datasheet')
    end
    respond_with(@product_datasheet) do |format|
      format.html { redirect_to admin_product_datasheets_path }
      format.js   { render :partial => "spree/admin/shared/destroy" }
    end
  end

  def clone
  end

  def create
    @product_datasheet = Spree::ProductDatasheet.new(permitted_resource_params)
    @product_datasheet.user = spree_current_user

    if @product_datasheet.save && @product_datasheet.xls.original_filename =~ /\.(xlsx?|ods|csv)$/
      if (defined? Delayed::Job) or (defined? Sidekiq)
        @product_datasheet.delay.perform
      else
        @product_datasheet.perform
      end
      flash.notice = Spree.t("notice_messages.product_datasheet_saved")
      redirect_to admin_product_datasheets_path
    else
      flash[:error] = "Failed to create the product datasheet"
      redirect_to admin_product_datasheets_path
    end
  end
end
