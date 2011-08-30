$:.push File.expand_path("../lib", __FILE__)
require 'helpers'

pool "ec2-setup" do  
  cloud "cassandra-cluster" do
    config = YAML::load(File.read("config.yml"))

    using :ec2
    keypair config['ec2']['keypair']

    ami_switches = <<-UDATA.gsub(/\s+/, " ").strip
      --clustername #{config['name']} 
      --clustersize #{config['size']} 
      --deployment #{config['type']}
    UDATA

    if using_opscenter?(config['opscenter'])
      ami_switches << " --opscenter #{config['opscenter']['username']}:#{config['opscenter']['password']}"
    end

    user_data ami_switches
    user :ubuntu

    instance_type config['ec2']['type']
    instances config['size'] # instances (config['size']..config['max-size'])

    # See http://www.datastax.com/dev/blog/setting-up-a-cassandra-cluster-with-the-datastax-ami
    image_id "ami-ed6d30a8" #"ami-edc30384"
    availability_zones config['ec2']['zones']

    security_group 'cassandra' do
      # Externally accessible ports
      jmx               = get_jmx_port(config) 
      ssh               = 22
      thrift            = 9160 # Cassandra clients
      opscenter_web     = 8888
      job_tracking      = 8012  # Brisk mapreduce job tracking clients
      job_tracking_web  = 50030 # Brisk mapreduce job tracking
      task_tracking_web = 50060 # Brisk mapreduce task tracking

      public_ports      = [jmx, ssh, thrift]
      public_ports      << opscenter_web if using_opscenter?(config['opscenter'])

      public_ports.concat([job_tracking, job_tracking_web, task_tracking_web]) if using_brisk?(config)
      public_ports.each {|port| authorize :from_port => port, :to_port => port }


      # Ports accessible only to Cassandra nodes
      gossip            = 7000
      opscenter_agents  = 8888

      private_ports     = [gossip] 
      private_ports     << opscenter_agents if using_opscenter?(config['opscenter'])
      private_ports.each {|port| authorize :from_port => port, :to_port => port, :group_name => 'cassandra' }
    end
  end
end
