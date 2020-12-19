module Partners
  class Partner < PartnersBase

    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable
  end
end
