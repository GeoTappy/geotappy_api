APN =  if Settings.apns.env == 'prod'
         Houston::Client.production
       else
         Houston::Client.development
       end

APN.certificate = File.read(File.join(Rails.root, 'certificates', Settings.apns.cert))
APN.passphrase = Settings.apns.passphrase
