class SysinfoController < ApplicationController

  if defined?(Rails.root)
    NAGIOS_PLUGINS = "#{Rails.root}/nagios-plugins"
  else
    NAGIOS_PLUGINS = File.dirname(__FILE__)+'/../../nagios-plugins'
  end

  def currentload
    textstr = `#{NAGIOS_PLUGINS}/check_load --warning='5.0,4.0,3.0' --critical='10.0,6.0,4.0'`
    textstr += 'Status Code: ' + $?.exitstatus.to_s + "\n"
    render :text => textstr, :status =>201
  end

  def currentusers
    textstr = `#{NAGIOS_PLUGINS}/check_users -w '5' -c '10'`
    textstr += 'Status Code: ' + $?.exitstatus.to_s + "\n"
    render :text => textstr, :status =>201
  end

  def diskspace
    textstr = `#{NAGIOS_PLUGINS}/check_disk -w '20%' -c '10%' -e`
    textstr += 'Status Code: ' + $?.exitstatus.to_s + "\n"
    render :text => textstr, :status =>201
  end

  def mongo
    # do nothing
  end

  def totalprocesses
    textstr = `#{NAGIOS_PLUGINS}/check_procs -w '250' -c '400'`
    textstr += 'Status Code: ' + $?.exitstatus.to_s + "\n"
    render :text => textstr, :status =>201
  end

  def swap
    textstr = `#{NAGIOS_PLUGINS}/check_swap -w '95%' -c '90%'`
    textstr += 'Status Code: ' + $?.exitstatus.to_s + "\n"
    render :text => textstr, :status =>201
  end
end
