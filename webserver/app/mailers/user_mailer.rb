   class UserMailer < ActionMailer::Base
      # Make sure to set this to your verified sender!
      default from: "mcnallm2@tcnj.edu"  

      def server_email(email)
        mail(:to => email, :subject => "Hello World!")
      end
    end 
