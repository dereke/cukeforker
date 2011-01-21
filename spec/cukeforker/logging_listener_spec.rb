require File.expand_path("../../spec_helper", __FILE__)

module CukeForker
  describe LoggingListener do
    let(:stdout)   { StringIO.new }
    let(:listener) { LoggingListener.new stdout }

    it "logs all events" do
      Time.stub(:now => Time.now)
      
      mock_worker = mock(Worker,     :id => "1", :feature => "foo/bar")
      mock_display = mock(VncServer, :display => ":5")
      
      listener.on_run_starting
      listener.on_display_fetched mock_display
      listener.on_worker_starting mock_worker
      listener.on_worker_finished mock_worker
      listener.on_display_released mock_display
      listener.on_run_interrupted
      listener.on_run_finished false
      
      timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S##{Process.pid}")
      
      stdout.string.should == <<-OUTPUT
I, [#{timestamp}]  INFO -- : [    run           ] starting
I, [#{timestamp}]  INFO -- : [    display::5    ] fetched
I, [#{timestamp}]  INFO -- : [    worker:1      ] starting: foo/bar
I, [#{timestamp}]  INFO -- : [    worker:1      ] finished: foo/bar
I, [#{timestamp}]  INFO -- : [    display::5    ] released
I, [#{timestamp}]  INFO -- : [    run           ] interrupted
I, [#{timestamp}]  INFO -- : [    run           ] finished, passed
      OUTPUT
    end



  end # Worker
end # CukeForker