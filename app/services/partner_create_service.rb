class PartnerCreateService
  include ServiceObjectErrorsMixin

  attr_reader :partner

  def initialize(organization_id:, partner_attributes:)
    @organization_id = organization_id
    @partner_attributes = partner_attributes
  end

  def call
    @partner = Partner.new(partner_attributes.merge(organization_id: organization_id))

    unless @partner.valid?
      @partner.errors.each do |k, v|
        errors.add(k, v)
      end
    end

    return self if errors.present?

    ApplicationRecord.transaction do
      @partner.save!

      @partnerbase_partner = Partners::Partner.new(
        diaper_bank_id: organization_id,
        diaper_partner_id: @partner.id
      )

      @partnerbase_partner.save!


      NotifyPartnerJob.perform_now(@organization_request.id)
    rescue StandardError => e
      errors.add(:base, e.message)
      raise ActiveRecord::Rollback
    end

    self
  end

  private

  attr_reader :organization_id, :partner_attributes

  def organization
    @organization ||= Organization.find(organization_id)
  end

end
