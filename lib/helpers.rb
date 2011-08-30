def using_opscenter?(config)
  !config.nil? && %w[username password].all? { |k| !config[k].nil? }
end

def using_brisk?(config)
  !config.nil? && config['type'] == 'brisk'
end

def get_jmx_port(config)
  return 8080 if config['type'] == '07x'
  7199
end 
