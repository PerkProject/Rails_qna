set :output, "/log/whenever.log"

every 1.day, at: '0:00 am' do
  runner "DailyDigestJob.perform_now"
end
