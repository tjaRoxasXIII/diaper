require 'rails_helper'

RSpec.describe PartnerCreateService, type: :service do
  describe '#call' do
    subject { described_class.new(args).call }
    let(:args) do
      {
        organization_id: organization_id,
        partner_attributes: partner_attributes
      }
    end
    let(:organization_id) { @organization.id }
    let(:partner_attributes) do
      params = ActionController::Parameters.new(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        send_reminders: false,
        quota: 0,
        notes: Faker::Lorem.paragraph,
        documents: []
      )
      params.permit!
      params
    end

    context 'when the arguments are incorrect' do
      context 'because no partner_attributes were defined' do
        let(:partner_attributes) { ActionController::Parameters.new.permit! }

        it 'should return the PartnerCreateService object with an error' do
          result = subject

          expect(result).to be_a_kind_of(PartnerCreateService)
          expect(result.errors[:name]).to eq(["can't be blank"])
        end
      end

      context 'because a unrecogonized organization_id was provided' do
        let(:organization_id) { 0 }

        it 'should return the PartnerCreateService object with an error' do
          result = subject

          expect(result).to be_a_kind_of(PartnerCreateService)
          expect(result.errors[:organization]).to include("must exist")
        end
      end
    end

    context 'when the arguments are correct' do

      it 'should create a Partner' do
        expect { subject }.to change { Partner.where(email: partner_attributes[:email]).count }.by(1)
      end

      it 'should create a Partners::Partner record' do
        expect { subject }.to change { Partners::Partner.where(diaper_bank_id: organization_id).count }.by(1)
      end

    end
  end
end

