module Admin
  class UserEvent < Admin::AdminBase

    def subject_line
      if event_type == 'backup'
        "AACT #{Rails.env.capitalize} User Backups"
      else
        "AACT #{Rails.env.capitalize} user #{event_type}: #{self.description}"
      end
    end

    def notification_message
      "AACT User information is saved to the attached SQL files.  User info can be restored with the following commands:
        First verify the schema defined in the file is correct (ctgov).
        in aact_admin db:
          truncate table users;
          truncate table user_events;
        psql -d aact_admin -a -f YYYYMMDD-aact-users_table.sql
        psql -d aact_admin -a -f YYYYMMDD-aact-user_events.sql

        On the public server that hosts the publicly accessible database:
        psql -d aact -a -f YYYYMMDD-aact-user_accounts.sql
        "
    end

  end
end
