class ApplicationMailbox < ActionMailbox::Base
  routing /@in.dinero-forward.dk/i => :purchases

  # google forwarding
  routing ->(inbound_email) { inbound_email.mail.x_forwarded_to_addresses.select { |x| x.address[/@in.dinero-forward.dk/i] }.any?  } => :purchases
end
