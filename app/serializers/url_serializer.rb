class UrlSerializer
  include JSONAPI::Serializer

  set_type :urls

  attribute 'created-at', &:created_at
  attribute 'original-url', &:original_url
  attribute :url do |object, params|
    params[:host] + object.short_url
  end

  attribute 'clicks', &:clicks_count
end