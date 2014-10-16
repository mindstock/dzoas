class PlanMailer < ActionMailer::Base
  default from: "btqnyao@163.com"

  def send_mail(params = {})
        # load_settings_default
        # @mail_body = params[:mail_body]
        @params = params
        mail(:subject => params[:subject],
               :to => params[:to],
               :from => "btqnyao@163.com",
               :date => Time.now
               )
  end
end
