class Book < ApplicationRecord
    validates :author, precence: true, legth: { minimum: 3}
    validates :title, precence: true, legth: { minimum: 3}
end
