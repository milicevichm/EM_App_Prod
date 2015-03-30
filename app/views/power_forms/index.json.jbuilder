json.array!(@power_forms) do |power_form|
  json.extract! power_form, :id, :appliance, :tstart, :tend
  json.url power_form_url(power_form, format: :json)
end
