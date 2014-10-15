RAILS_ROOT = "/home/ec2-user/miner"
PID_FILE = "tmp/pids/server.pid"
SIDEKIQ_PID_FILE = "tmp/pids/sidekiq.pid"

God.watch do |w|
	w.dir = RAILS_ROOT
	w.env = { 'RAILS_ROOT' => "#{RAILS_ROOT}",
                  'RAILS_ENV' => "production" }
	w.name = "actron-rails-3000"
	w.start = "cd #{RAILS_ROOT}; bin/rails server -d -e production " 
	w.keepalive
	w.stop = "cd #{RAILS_ROOT}; kill -9 `cat #{PID_FILE}`"
	w.restart = "cd #{RAILS_ROOT}; kill -9 `cat #{PID_FILE}`; bin/rails server -d -e production"
	w.pid_file = File.join(RAILS_ROOT,"#{PID_FILE}")

	w.behavior(:clean_pid_file)
       	w.start_if do |start|
           	start.condition(:process_running) do |c|
             		# We want to check if deamon is running every ten seconds
             		# and start it if itsn't running
             		c.interval = 10.seconds
             		c.running = false
        	end
  	end

end

God.watch do |w|
        w.dir = RAILS_ROOT
        w.env = { 'RAILS_ROOT' => "#{RAILS_ROOT}",
                  'RAILS_ENV' => "production" }
        w.name = "actron-scraper-3000"
        w.start = "cd #{RAILS_ROOT}; bin/sidekiq -L config/sidekiq.log -e production -d -C config/sidekiq.yml"
	w.stop = "cd #{RAILS_ROOT}; kill -9 `cat #{SIDEKIQ_PID_FILE}`"
	w.restart = "cd #{RAILS_ROOT}; kill -9 `cat #{SIDEKIQ_PID_FILE}`; bin/sidekiq -L config/sidekiq.log -e production -d -C config/sidekiq.yml"
        w.keepalive
	w.pid_file = File.join(RAILS_ROOT,"#{SIDEKIQ_PID_FILE}")

	w.behavior(:clean_pid_file)
       	w.start_if do |start|
           	start.condition(:process_running) do |c|
             		# We want to check if deamon is running every ten seconds
             		# and start it if itsn't running
             		c.interval = 10.seconds
             		c.running = false
        	end
  	end
end

