$:.push File.expand_path("../lib", __FILE__)
require 'helpers'

pool "ec2-setup" do  
  cloud "cassandra-cluster" do
    config = YAML::load(File.read("config.yml"))
    ports = config['ports']

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
    image_id "ami-ed6d30a8"
    availability_zones config['ec2']['zones']

    security_group 'cassandra' do
      brisk_ports       = [ports['job_tracking'], ports['job_tracking_web'], ports['task_tracking_web']]

      public_ports      = [get_jmx_port(config), ports['ssh'], ports['thrift']]
      public_ports      << ports['opscenter_web'] if using_opscenter?(config['opscenter'])
      public_ports.concat(brisk_ports) if using_brisk?(config)
      public_ports.each {|port| authorize :from_port => port, :to_port => port }


      private_ports     = [ports['gossip']] 
      private_ports     << ports['opscenter_agents'] if using_opscenter?(config['opscenter'])
      private_ports.each {|port| authorize :from_port => port, :to_port => port, :group_name => 'cassandra' }
    end

    load_balancer do
      listener :external_port => ports['thrift'], :internal_port => ports['thrift'], :protocol => 'tcp'
    end
  end
end
