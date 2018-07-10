require 'rubygems'
require 'fabricio'
require 'date'

client = Fabricio::Client.new do |config|
  config.username = ARGV[0]
  config.password = ARGV[1]
end

organization_id = ARGV[2]
app_id = ARGV[3]
daily_new_users = 0
daily_active_users = 0
purchases = 0
logins = 0
signups = 0
add_to_carts = 0
start_checkouts = 0
bundle_id = client.app.get(app_id:app_id).bundle_id

result = ""
client.app.daily_new(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60)).each{|x| daily_new_users =  x.value }
client.app.daily_active(app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),build: 'all').each{|x| daily_active_users = x.value }
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'purchase',build: 'all').each{|x| purchases = x.value}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'login',build: 'all').each{|x| logins = x.value}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'sign-up',build: 'all').each{|x| signups = x.value}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'add-to-cart',build: 'all').each{|x| add_to_carts = x.value}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'start-checkout',build: 'all').each{|x| start_checkouts = x.value}

if daily_new_users < 15 || daily_active_users < 400 || purchases < 5 || logins < 50 || signups < 1 || add_to_carts < 400 || start_checkouts < 10 then
	result += "\n#{bundle_id} NEEDS ATTENTION !!!!! \n"
else
	result += "\n#{bundle_id} LOOKS OK\n\n"
end

result += "#{client.app.active_now(organization_id: organization_id, app_id: app_id)} active users now\n"
result += "#{daily_new_users} new users for yesterday\n"
result += "#{daily_active_users} daily active users for yesterday\n"
result += "#{purchases} purchases yesterday\n"
result += "#{logins} logins yesterday\n"
result += "#{signups} signups yesterday\n"
result += "#{add_to_carts} add to carts yesterday\n"
result += "#{start_checkouts} start checkouts yesterday\n"
puts result
