# frozen_string_literal: true

require "rails_helper"

RSpec.describe DelegateStatusChangeMailer, type: :mailer do
  describe "notify_board_and_wqac_of_delegate_status_change" do
    let(:senior_delegate1) { FactoryBot.create :senior_delegate }
    let(:senior_delegate2) { FactoryBot.create :senior_delegate }
    let(:delegate) { FactoryBot.create :delegate, senior_delegate: senior_delegate1 }
    let(:mail) { DelegateStatusChangeMailer.notify_board_and_wqac_of_delegate_status_change(delegate, senior_delegate2) }

    it "renders" do
      expect(mail.to).to eq(["board@worldcubeassociation.org"])
      expect(mail.cc).to eq(["quality@worldcubeassociation.org"])
      expect(mail.from).to eq(["notifications@worldcubeassociation.org"])
      expect(mail.reply_to).to eq([senior_delegate2.email])
      expect(mail.subject).to eq("#{senior_delegate2.name} just changed the Delegate status of #{delegate.name}")
      expect(mail.body.encoded).to match ("#{senior_delegate2.name} has changed the Delegate status of #{delegate.name} from #{delegate.delegate_status_was_name} to #{delegate.delegate_status_name}.")
      expect(mail.body.encoded).to match ("Warning: #{senior_delegate2.name} is not #{delegate.name}'s Senior Delegate.")
      expect(mail.body.encoded).to match(edit_user_url(delegate))
    end
  end
end
