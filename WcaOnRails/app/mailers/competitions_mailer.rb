# frozen_string_literal: true

require 'fileutils'

class CompetitionsMailer < ApplicationMailer
  helper :markdown

  def notify_board_of_confirmed_competition(confirmer, competition)
    @competition = competition
    @confirmer = confirmer
    mail(
      to: "board@worldcubeassociation.org",
      cc: competition.delegates.pluck(:email) + competition.delegates.map { |d| d.senior_delegate&.email }.compact.uniq,
      reply_to: confirmer.email,
      subject: "#{confirmer.name} just confirmed #{competition.name}",
    )
  end

  def notify_users_of_results_presence(user, competition)
    @competition = competition
    @user = user
    mail(
      to: user.email,
      subject: "The results of #{competition.name} are posted",
      reply_to: competition.delegates.pluck(:email),
    )
  end

  def notify_users_of_id_claim_possibility(user, competition)
    @competition = competition
    mail(
      to: user.email,
      reply_to: competition.delegates.pluck(:email),
      subject: "Please link your WCA ID with your account",
    )
  end

  def notify_of_delegate_report_submission(competition)
    I18n.with_locale :en do
      @competition = competition
      mail(
        to: "delegates@worldcubeassociation.org",
        cc: competition.delegates.pluck(:email),
        reply_to: competition.delegates.pluck(:email),
        subject: "[wca-report] [#{competition.continent.name}] #{competition.name}",
      )
    end
  end

  def submit_results_nag(competition)
    @competition = competition
    mail(
      to: competition.delegates.pluck(:email),
      cc: ["results@worldcubeassociation.org"] + delegates_to_senior_delegates_email(competition.delegates),
      reply_to: "results@worldcubeassociation.org",
      subject: "#{competition.name} Results",
    )
  end

  def submit_report_nag(competition)
    @competition = competition
    mail(
      to: competition.delegates.pluck(:email),
      cc: ["board@worldcubeassociation.org"] + delegates_to_senior_delegates_email(competition.delegates),
      reply_to: "board@worldcubeassociation.org",
      subject: "#{competition.name} Delegate Report",
    )
  end

  def results_submitted(competition, message, sender_name, file_contents)
    @competition = competition
    @message = message
    @sender_name = sender_name
    file_name = "Results_#{competition.id}_#{Time.now.utc.iso8601}.json"
    attachments[file_name] = file_contents
    mail(
      to: "results@worldcubeassociation.org",
      cc: competition.delegates.pluck(:email),
      reply_to: competition.delegates.pluck(:email),
      subject: "Results for #{competition.name}",
    )
  end

  private def delegates_to_senior_delegates_email(delegates)
    delegates.map { |delegate| delegate.senior_delegate&.email }.uniq.compact
  end
end
