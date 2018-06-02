# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/wca_id_claim_mailer
class DelegateStatusChangeMailerPreview < ActionMailer::Preview
  def notify_board_and_wqac_of_delegate_status_change
    ActiveRecord::Base.transaction do
      user_whose_delegate_status_changes = User.where.not(delegate_status: nil).first
      senior_delegate_making_the_change = User.where(delegate_status: "senior_delegate").first
      DelegateStatusChangeMailer.notify_board_and_wqac_of_delegate_status_change(user_whose_delegate_status_changes, senior_delegate_making_the_change)
    end
  end
end
