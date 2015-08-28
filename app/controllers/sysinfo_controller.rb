class SysinfoController < ApplicationController
  def currentload
    render :text => `nagios-plugins/check_load --warning='5.0,4.0,3.0' --critical='10.0,6.0,4.0'`, :status =>201
  end

  def currentusers
    render :text => `nagios-plugins/check_users -w '5' -c '10'`, :status =>201
  end

  def diskspace
    render :text => `nagios-plugins/check_disk -w '20%' -c '10%' -e`, :status =>201
  end

  def mongo
  end

  def totalprocesses
    render :text => `nagios-plugins/check_procs -w '250' -c '400'`, :status =>201
  end

  def swap
    render :text => `nagios-plugins/check_swap -w '95%' -c '90%'`, :status =>201
  end
end
