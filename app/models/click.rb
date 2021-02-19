# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  scope :count_by_last_days, -> (days) {
    select('TO_CHAR("created_at", \'DD/MM/YYYY\') AS day, COUNT(*) AS total').
    where('created_at >= ?', days.days.ago.beginning_of_day).
    group(:day)
  }
  scope :count_by_browser, -> { select('browser, COUNT(*) AS total').group(:browser) }
  scope :count_by_platform, -> { select('platform, COUNT(*) AS total').group(:platform) }

  after_create :increase_clicks_count

  def increase_clicks_count
    Url.increment_counter(:clicks_count, url_id, touch: true)
  end
end
