class Portfolio
  include DataMapper::Resource

  has n, :stocks

  property :id,           Serial
  property :name,         String
  property :stock_id,     Integer
  property :created_at,   DateTime

  DataMapper.auto_upgrade!
end
