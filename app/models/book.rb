class Book < ApplicationRecord
  include PGEnum(genres: %w[Fiction Nonfiction Mystery Romance Novel])

  belongs_to :author
end
