# frozen_string_literal: true

class DelegateStatusChangeMailer < ApplicationMailer
  def notify_board_and_wqac_of_delegate_status_change(user_whose_delegate_status_changes, user_senior_delegate)
    @user_whose_delegate_status_changes = user_whose_delegate_status_changes
    @user_senior_delegate = user_senior_delegate
    to = ["board@worldcubeassociation.org"]
    cc = ["quality@worldcubeassociation.org"]
    mail(
      to: to,
      cc: cc,
      reply_to: user_senior_delegate.email,
      subject: "#{user_senior_delegate.name} just changed the Delegate status of #{user_whose_delegate_status_changes.name}",
    )
  end
end
