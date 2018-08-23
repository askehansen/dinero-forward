# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/upload_complete
  def upload_complete
    UserMailer.upload_complete
  end

  def done
    UserMailer.done(Purchase.last.message)
  end

  def received
    UserMailer.received(Purchase.last.message)
  end

  def no_attachments
    message = Message.new(
      email: "123@dinero-forward.dk",
      from_name: "Aske hansen",
      from_email: "aske@deeco.dk",
      created_at: DateTime.now,
      subject: "Kvittering",
      body: "Hej aske\n\n---\nMed venlig hilsen\n\nAske Hansen\nwww.deeco.dk\n+45 31 60 03 03"
    )
    UserMailer.no_attachments(message)
  end

  def gmail_forwarding
    message = Message.new(
      user_id: "1234",
      from_email: "forwarding-noreply@google.com",
      from_name: "\"company\"",
      email: "1234@dinero-forward.dk",
      subject: "(#12345) company Bekræftelse af videresendelse - Modtag e-mail fra invoice@company.com",
      created_at: 'Mon, 18 Dec 2017 10:20:33 CET +01:00',
      updated_at: 'Mon, 18 Dec 2017 10:20:33 CET +01:00',
      status: "unprocessed",
      lock_version: 0,
      body:
      "invoice@company.com har anmodet om tilladelse til automatisk at\nvideresende e-mail til din mailadresse\n1234@dinero-forward.dk.\nBekræftelseskode: 12345\n\nHvis du vil give tilladelse til, at invoice@company.com automatisk\nvideresender e-mail til din adresse, skal du bekræfte anmodningen ved\nat klikke på følgende link:\n\nhttps://mail-settings.google.com/mail/wefwe\n\nHvis du klikker på linket, og linket ser ud til at være brudt, skal du\nkopiere linket og sætte det ind i et nyt browservindue. Hvis du ikke\nkan få adgang til linket, kan du sende bekræftelseskoden til\n12345 til invoice@company.com.\n\nTak, fordi du bruger company!\n\nVenlig hilsen\n\ncompany\n\nHvis du ikke ønsker at godkende denne anmodning, skal du ikke foretage\ndig yderligere.\ninvoice@company.com kan ikke automatisk videresende e-mail til din\nmailadresse, medmindre du bekræfter anmodningen ved at klikke på\novenstående link. Hvis du ved en fejl er kommet til at klikke på\nlinket, men ikke ønsker at give invoice@company.com tilladelse til\nautomatisk at videresende meddelelser til din adresse, kan du\nannullere bekræftelsen ved at klikke på følgende link:\nhttps://mail-settings.google.com/mail/askljsad\n\nDu kan få mere at vide om, hvorfor du har modtaget denne meddelelse,\nved at gå til: http://support.google.com/mail/bin/answer.py?answer=184973.\n\nDet er ikke muligt at besvare denne e-mail. Hvis du vil kontakte\nGoogle.com-teamet, skal du logge ind på din konto og klikke på 'Hjælp'\ni toppen af en vilkårlig side. Klik derefter på \"'Kontakt os\" nederst\npå siden med Hjælp."
    )

    UserMailer.gmail_forwarding(message)
  end

end
