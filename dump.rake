require "date"
require "dotenv"
require "fog"
require "rest_client"
require "zlib"

namespace :postgres do
  desc "Dumps a postgres DB and uploads the file to an S3 bucket"
  task :dump do
    Dotenv.load

    puts "Starting dump...."
    command = "PGPASSWORD=#{ENV['PGPASSWORD']} pg_dump -Fc --no-acl --no-owner -h #{ENV['PGHOST']} -U #{ENV['PGUSER']} -p #{ENV['PGPORT']} #{ENV['PGDATABASE']} > postgres.dump"
    Kernel.system(command)
    puts "Finished dump."

    puts "Starting upload...."
    connection = Fog::Storage.new({
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    })

    if File.zero?("./postgres.dump")
      if ENV['SLACK_URL']
        slack_params = { text: "Database backup has failed", channel: "##{ENV["SLACK_CHANNEL"]}", username: ENV["SLACK_USERNAME"], icon_emoji: ":floppy_disk:" }
        RestClient.post(ENV['SLACK_URL'], slack_params.to_json)
      end
    else
      month_name = "#{Date.today.month} - #{Date::MONTHNAMES[Date.today.month]}"
      connection.put_object(ENV["AWS_BUCKET"], "#{ENV['ENVIRONMENT']}/#{Date.today.year}/#{month_name}/#{Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')}.dump", File.open("./postgres.dump"))
      puts "Finished upload."

      if ENV['SLACK_URL']
        slack_params = { text: "Database backup has completed successfully and has been uploaded to S3", channel: "##{ENV["SLACK_CHANNEL"]}", username: ENV["SLACK_USERNAME"], icon_emoji: ":floppy_disk:" }
        RestClient.post(ENV['SLACK_URL'], slack_params.to_json)
      end
    end
  end
end