# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is a valid URL' do
      url = Url.new({ original_url: 'http://www.uol.com.br' })
      expect(url.valid?).to be_truthy

      url.original_url = 'https://www.uol.com'
      expect(url.valid?).to be_truthy
      expect(url.short_url.length).to eq(5)
      expect(url.short_url.match?(/a-z/)).not_to be_truthy
      expect(url.short_url.match?(/^a-zA-Z\d/)).not_to be_truthy
      expect(url.short_url.match?(/^\s/)).not_to be_truthy
    end

    it 'validates original URL accept only a unique URL' do
      url_a = Url.create({ original_url: 'http://www.uol.com.br' })
      url_b = Url.create({ original_url: 'http://www.uol.com' })

      expect(url_b.update({ short_url: url_a.short_url })).not_to be_truthy
    end

    it 'validates original URL is not a valid URL' do
      url = Url.new
      expect(url.valid?).not_to be_truthy

      url.original_url = 'www.uol.com'
      expect(url.valid?).not_to be_truthy

      url.original_url = 'www'
      expect(url.valid?).not_to be_truthy

      url.original_url = '.com'
      expect(url.valid?).not_to be_truthy

      url.original_url = '123.123'
      expect(url.valid?).not_to be_truthy
    end
  end
end
