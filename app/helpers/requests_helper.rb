# Encapsulates methods that need some business logic
module RequestsHelper
  def requested_item_count_over_limit?(request)
    return false unless request.partner.distribution_limit > 0

    request.requested_item_count > request.partner.distribution_limit
  end
end
