require 'influxdb'
require 'softbank_healthcare'

host = '153.126.211.227'
database = 'prometheus'
time_precision = 's'

influxdb = InfluxDB::Client.new database, :time_precision => time_precision, :host => host

client = SoftBankHealthCare::Client.new telno: ENV['SOFTBANK_HEALTHCARE_TELNO'], password: ENV['SOFTBANK_HEALTHCARE_PASSWORD']

# 適時書き換えて下さい
base = {
	:tags => {
		:instance => "xxx.herokuapp.com:80",
		:job => "heroku",
		:monitor => "codelab-monitor",
	},
	:values => {:value => 0},
}

for num in 1..90 do
	date = Date.today - num
	client.date = date

	data = base
	data[:timestamp] = date.to_time.to_i

	data[:values][:value] = client.weight.to_f
	influxdb.write_point("softbank_healthcare_weight", data)

	data[:values][:value] = client.body_fat.to_f
	influxdb.write_point("softbank_healthcare_body_fat", data)

	data[:values][:value] = client.bmi.to_f
	influxdb.write_point("softbank_healthcare_bmi", data)

	data[:values][:value] = client.basal_metabolism.to_f
	influxdb.write_point("softbank_healthcare_basal_metabolism", data)

	data[:values][:value] = client.physical_age.to_f
	influxdb.write_point("softbank_healthcare_physical_age", data)

	data[:values][:value] = client.skeletal_muscle_level.to_f
	influxdb.write_point("softbank_healthcare_skeletal_muscle_level", data)

	data[:values][:value] = client.bone_level.to_f
	influxdb.write_point("softbank_healthcare_bone_level", data)

	data[:values][:value] = client.visceral_fat_level.to_f
	influxdb.write_point("softbank_healthcare_visceral_fat_level", data)

	data[:values][:value] = client.water_content.to_f
	influxdb.write_point("softbank_healthcare_water_content", data)
end
