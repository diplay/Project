class ComponentServicesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"
    
  def destroy
    ComponentService.find(params[:id]).destroy
    redirect_to :back
  end

  def show
    print(params)
  end
end
