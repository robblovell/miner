RAILS_ROOT = "/home/ec2-user/miner"
PID_FILE = "tmp/pids/server.pid"

God.watch do |w|
	w.dir = RAILS_ROOT
	w.env = { 'RAILS_ROOT' => "#{RAILS_ROOT}",
                  'RAILS_ENV' => "production" }
	w.name = "actron-scraper-3000"
	w.start = "cd #{RAILS_ROOT}; bin/rails server " 
	w.keepalive
	#w.stop = "cd #{RAILS_ROOT}; kill -9 `cat #{PID_FILE}`"
	#w.restart = "cd #{RAILS_ROOT}; kill -9 `cat #{PID_FILE}`; bin/rails server -d"
	#w.pid_file = File.join(RAILS_ROOT,"#{PID_FILE}")

	#w.behavior(:clean_pid_file)

end
