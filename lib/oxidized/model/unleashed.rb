class Unleashed < Oxidized::Model
  using Refinements

  # for Ruckus Unleashed wireless access points
  
  prompt /^([\w.@()-]+[#>]\s?)$/
  
  cmd :all do |cfg|
    # Remove extra lines, excessive CRLF sequences, add final LF
    cfg.cut_both.gsub /(\r\n)/, '' + "\n"
  end

  cmd :secret do |cfg|
    # Administrator Name/Password:
    cfg.gsub! /(Password=).*/, '\1 <hidden>'
    # SSID Passphrase
    cfg.gsub! /(Passphrase =).*/, '\1 <hidden>'
    # SNMPv2
    cfg.gsub! /(RO Community=).*/, '\1 <hidden>'
    cfg.gsub! /(RW Community=).*/, '\1 <hidden>'
    # SNMPv3
    cfg.gsub! /(Authentication Pass Phrase=).*/, '\1 <hidden>'
    cfg.gsub! /(Privacy Phrase=).*/, '\1 <hidden>'
    # Smart Redundancy
    cfg.gsub! /(Shared Secret=).*/, '\1 <hidden>'
    # Unleashed Network
    cfg.gsub! /(Token=).*/, '\1 <hidden>'
    cfg
  end

  cmd 'show sysinfo' do |cfg|
    # Truncate dynamic system data beyond 8 lines
    cfg = cfg.lines.take(8).join
    # Remove uptime
    cfg.gsub! /(Uptime=).*/, '\1 <removed>'
  end

  cmd 'show ethinfo'

  cmd 'show config'

  cfg :ssh do
    username /(Please login:)/
    password /(Password:)/
    
    post_login 'enable'
    pre_logout 'exit'
  end
end

