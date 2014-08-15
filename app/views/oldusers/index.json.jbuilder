json.array!(@artists) do |artist|
  json.extract! artist, :id, :name, :email, :password_hash, :place, :art_piece, :art_piece_price, :wepay_access_token, :wepay_account_id
  json.url artist_url(artist, format: :json)
end
