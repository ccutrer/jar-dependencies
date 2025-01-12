# frozen_string_literal: true

require "sinatra"
require "json"
require "ostruct"
require "leafy/metrics"
require "leafy/health"
require "leafy/instrumented/instrumented"
require "leafy/instrumented/collected_instrumented"
require "leafy/rack/admin"
require "leafy/rack/instrumented"

Data = Struct.new(:surname, :firstname)
data = Data.new("meier", "christian")

configure do
  metrics = Leafy::Metrics::Registry.new
  health = Leafy::Health::Registry.new

  use(Leafy::Rack::Admin, metrics, health)
  use(Leafy::Rack::Metrics, metrics)
  use(Leafy::Rack::Health, health)
  use(Leafy::Rack::Ping)
  use(Leafy::Rack::ThreadDump)
  use(Leafy::Rack::Instrumented, Leafy::Instrumented::Instrumented.new(metrics, "webapp"))
  use(Leafy::Rack::Instrumented, Leafy::Instrumented::CollectedInstrumented.new(metrics, "collected"))

  metrics.register_gauge("app.data_length") do
    data.surname.length + data.firstname.length
  end

  health.register("app.health") do
    "stored names are too short" if data.surname.length + data.firstname.length < 4
  end

  set :histogram, metrics.register_histogram("app.name_length")
end

get "/app" do
  p @person = data
  erb :person
end

get "/person" do
  p @person = data
  content_type "application/json"
  { surname: data.surname, firstname: data.firstname }.to_json
end

patch "/person" do
  payload = JSON.parse request.body.read
  data.send :"#{payload.keys.first}=", payload.values.first
  settings.histogram.update(data.surname.length + data.firstname.length)
  status 205
end
