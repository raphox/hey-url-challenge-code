# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.all.order({ created_at: :desc })
  end

  def create
    @url = Url.create({ original_url: params[:url][:original_url] })

    flash[:error] = @url.errors.full_messages unless @url.save

    redirect_to urls_path
  end

  def show
    @url = Url.find_by!({ short_url: params[:url] })

    # implement queries
    @daily_clicks = @url.clicks.count_by_last_days(10).map { |item| [item.day, item.total] }
    @browsers_clicks = @url.clicks.count_by_browser.map { |item| [item.browser, item.total] }
    @platform_clicks = @url.clicks.count_by_platform.map { |item| [item.platform, item.total] }
  end

  def visit
    @url = Url.find_by!({ short_url: params[:url] })

    @url.clicks.create({ browser: request.env['HTTP_USER_AGENT'], platform: operating_system })

    redirect_to @url.original_url
  end

  private

  def operating_system
    case request.env['HTTP_USER_AGENT'].downcase
    when /mac/i then 'Mac'
    when /windows/i then 'Windows'
    when /linux/i then 'Linux'
    when /unix/i then 'Unix'
    else
      'Unknown'
    end
  end
end
