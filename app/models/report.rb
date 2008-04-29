class Report < OpenMRS
  set_table_name "report"
  belongs_to :user, :foreign_key => :user_id
#report_id
  set_primary_key "report_id"

  def self.cache
    #TODO fix this so that it uses render_to_string instead of wget
    # these need to be added to controllers/application to make sure logins aren't required
    # These are all URLs that should be cached
    q="Q2+" + Date.today.year.to_s
    q2="Q1+" + Date.today.year.to_s
    q3="Q4+" + (Date.today.year - 1).to_s
    q4="Q3+"  + (Date.today.year - 1).to_s
    q5="Q2+"  + (Date.today.year - 1).to_s

    urls = [
           "reports/cohort/Cumulative",
           "reports/virtual_art_register",
          # These reports are crashing. Test them before enabling
          # "reports/missed_appointments",
          # "reports/height_weight_by_user",
           "reports/defaulters",
           "reports/cohort/#{q}",
           "reports/cohort/#{q2}",
           "reports/cohort/#{q3}",
           "reports/cohort/#{q4}",
           "reports/cohort/#{q5}"
           ]

    #base_url = request.env["HTTP_HOST"]
    base_url = "localhost"
    base_url += ":3000" if RAILS_ENV == "development"
    @urls = Hash.new

    urls.each{|report_url|
      #public_path = "cached/#{report_url}.html"
      #public_path.gsub!(/\?/, "_")
      #public_path.gsub!(/%20/, "_")
      #output_document = "#{RAILS_ROOT}/public/#{public_path}"
      output_document = "/tmp/bart_last_cached_report.html"
      original_url = "http://#{base_url}/#{report_url}"
      #cached_url = "http://#{base_url}/#{public_path}"
      command = "wget --timeout=5000 --output-document #{output_document} #{original_url}?refresh"
      #command = "wget --timeout=5000  #{original_url}?refresh"
      #@urls[original_url] = cached_url
# Start this in a thread, otherwise we can block the whole app (depending on how concurrency is setup)
      Thread.new{
        #yell "#{command}"
        #yell `#{command}`
        `#{command}`
      }
    }

  end

  def self.survival_analysis_hash(all_patients, start_date, end_date, outcome_end_date, count)
    registration_start_date = start_date
    registration_end_date = end_date
    outcome_end_date = outcome_end_date
    @outcomes = Hash.new

    @outcomes["Defaulted"] = 0
    @outcomes["On ART"] = 0
    @outcomes["Died"] = 0
    @outcomes["ART Stop"] = 0
    @outcomes["Transfer out"] = 0

    # TODO: Optimise. Loop through all patients once and assign each art patient
    # to an approproate Survival entry without breaking @outcomes['Total']
    @patients = all_patients.collect{|p| 
      p if p.date_started_art and 
           p.date_started_art.between?(registration_start_date.to_time, registration_end_date.to_time)
    }.compact

    @outcomes["Title"] = "#{count*12} month survival: outcomes by end of #{outcome_end_date.strftime('%B %Y')}"
    @outcomes["Total"] = @patients.length
    @outcomes["Start Date"] = start_date
    @outcomes["End Date"] = end_date
    
    @patients.each{|patient|
      patient_outcome = patient.cohort_outcome_status(registration_start_date, outcome_end_date)

      if patient_outcome.downcase.include?("on art") and patient.defaulter?(outcome_end_date) 
        @outcomes["Defaulted"] += 1
      elsif patient_outcome.include?("Died")
        @outcomes["Died"] += 1
      elsif patient_outcome.include?("ART Stop")
        @outcomes["ART Stop"] += 1
      elsif patient_outcome.include?("Transfer")
        @outcomes["Transfer out"] += 1
      elsif patient_outcome.downcase.include?("on art")
        @outcomes["On ART"] += 1
      else
        if @outcomes.has_key?(patient_outcome) then
          @outcomes[patient_outcome] += 1
        else
          @outcomes[patient_outcome] = 1
        end
      end

    }
    return @outcomes
  end
 

end


### Original SQL Definition for report #### 
#   `report_id` int(11) NOT NULL auto_increment,
#   `name` varchar(255) NOT NULL default '',
#   `description` text,
#   `creator` int(11) NOT NULL default '0',
#   `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
#   `changed_by` int(11) default NULL,
#   `date_changed` datetime default NULL,
#   `voided` tinyint(1) default NULL,
#   `voided_by` int(11) default NULL,
#   `date_voided` datetime default NULL,
#   `void_reason` varchar(255) default NULL,
#   PRIMARY KEY  (`report_id`),
#   KEY `report_creator` (`creator`),
#   KEY `user_who_changed_report` (`changed_by`),
#   KEY `user_who_voided_report` (`voided_by`),
#   CONSTRAINT `report_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
#   CONSTRAINT `user_who_changed_report` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`),
#   CONSTRAINT `user_who_voided_report` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
