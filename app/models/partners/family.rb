# == Schema Information
#
# Table name: families
#
#  id                        :bigint           not null, primary key
#  comments                  :text
#  guardian_country          :string
#  guardian_employed         :boolean
#  guardian_employment_type  :jsonb
#  guardian_first_name       :string
#  guardian_health_insurance :jsonb
#  guardian_last_name        :string
#  guardian_monthly_pay      :decimal(, )
#  guardian_phone            :string
#  guardian_zip_code         :string
#  home_adult_count          :integer
#  home_child_count          :integer
#  home_young_child_count    :integer
#  military                  :boolean          default(FALSE)
#  sources_of_income         :jsonb
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  agency_guardian_id        :string
#  partner_id                :bigint
#
module Partners
  class Family < Base
    belongs_to :partner
    has_many :children, dependent: :destroy

    include Filterable

    filterrific(
      available_filters: [
        :search_guardian_names,
        :search_agency_guardians
      ],
    )

    scope :search_guardian_names, ->(query) { where('guardian_first_name ilike ? OR guardian_last_name ilike ?', "%#{query}%", "%#{query}%") }
    scope :search_agency_guardians, ->(query) { where('agency_guardian_id ilike ?', "%#{query}%") }

    INCOME_TYPES = %w[SSI SNAP/FOOD\ Stamps TANF WIC Housing/subsidized Housing/unsubsidized N/A].freeze
    INSURANCE_TYPES = %w[Private\ insurance Medicaid Uninsured].freeze
    EMPLOYMENT_TYPES = %w[Full-time Part-time N/A].freeze
  end
end

