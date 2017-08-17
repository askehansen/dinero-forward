namespace :purchases do
  desc "Process all unprocessed purchases"
  task process: :environment do
    Purchase.unprocessed.find_each do |purchase|
      ProcessPurchase.call(purchase: purchase)
    end
  end

end
