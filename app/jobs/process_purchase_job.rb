class ProcessPurchaseJob < ApplicationJob
  queue_as :purchases

  def perform(purchase)
    ProcessPurchase.call(purchase: purchase) if purchase.unprocessed?
  end

end
