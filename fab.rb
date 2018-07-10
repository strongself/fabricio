require 'rubygems'
require 'fabricio'
require 'date'

client = Fabricio::Client.new do |config|
  config.username = ARGV[0]
  config.password = ARGV[1]
end

organization_id = ARGV[2]
app_id = ARGV[3]

result = "#{client.app.active_now(organization_id: organization_id, app_id: app_id)} active users now\n"
client.app.daily_new(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60)).each{|x| result +=  "#{x.value} new users for yesterday\n" }
client.app.daily_active(app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),build: 'all').each{|x| result += "#{x.value} daily active users for yesterday\n" }
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'purchase',build: 'all').each{|x| result += "#{x.value} purchases yesterday\n"}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'login',build: 'all').each{|x| result += "#{x.value} logins yesterday\n"}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'sign-up',build: 'all').each{|x| result += "#{x.value} signups yesterday\n"}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'add-to-cart',build: 'all').each{|x| result += "#{x.value} add to carts yesterday\n"}
client.app.custom_event_total(organization_id: organization_id,app_id: app_id,start_time: (Time.now.to_i-24*60*60),end_time: (Time.now.to_i-24*60*60),event_type: 'start-checkout',build: 'all').each{|x| result += "#{x.value} start checkouts yesterday\n"}

puts result