#coding: utf-8
class AdminToolsController < ApplicationController
  helper :all
  before_action :check_admin
  before_action :set_show_menu
  layout 'admin'

  private

  def set_show_menu
    @showmenu = params[:showmenu] || true
    @for_print = request.fullpath.dup
    if @for_print.include?('?')
      @for_print << "&showmenu=false"
    else
      @for_print << "?showmenu=false"
    end

  end

end
