class Notifier < ActionMailer::Base
  default :from => "from@example.com"
  
   def welcome
    #@account = recipient
    mail(:to => 'bachans@mindfiresolutions.com',
         :subject => "Welcome to My Awesome Site")
    end
end
