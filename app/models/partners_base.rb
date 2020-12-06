class PartnersBase < ApplicationRecord
  self.abstract_class = true

  establish_connection :partners
end
