class Image < ApplicationRecord
    validates :prompt, length: { maximum: 65_535 }, presence: true
end
