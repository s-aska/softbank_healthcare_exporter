require 'rack'
require 'prometheus/client'
require 'prometheus/client/formats/text'
require 'softbank_healthcare'

prometheus = Prometheus::Client.registry

@weight = prometheus.gauge(:softbank_healthcare_weight, 'Softbank Healthcare 体重(kg)')
@body_fat = prometheus.gauge(:softbank_healthcare_body_fat, 'Softbank Healthcare 体脂肪率(%)')
@bmi = prometheus.gauge(:softbank_healthcare_bmi, 'Softbank Healthcare BMI')
@basal_metabolism = prometheus.gauge(:softbank_healthcare_basal_metabolism, 'Softbank Healthcare 基礎代謝')
@physical_age = prometheus.gauge(:softbank_healthcare_physical_age, 'Softbank Healthcare 身体年齢(歳)')
@skeletal_muscle_level = prometheus.gauge(:softbank_healthcare_skeletal_muscle_level, 'Softbank Healthcare 骨格筋レベル')
@bone_level = prometheus.gauge(:softbank_healthcare_bone_level, 'Softbank Healthcare 骨レベル')
@visceral_fat_level = prometheus.gauge(:softbank_healthcare_visceral_fat_level, 'Softbank Healthcare 内臓脂肪レベル')
@water_content = prometheus.gauge(:softbank_healthcare_water_content, 'Softbank Healthcare 水分量 (%)')

format = Prometheus::Client::Formats::Text

@client = SoftBankHealthCare::Client.new telno: ENV['SOFTBANK_HEALTHCARE_TELNO'], password: ENV['SOFTBANK_HEALTHCARE_PASSWORD']

def collect()
  @weight.set({}, @client.weight)
  @body_fat.set({}, @client.body_fat)
  @bmi.set({}, @client.bmi)
  @basal_metabolism.set({}, @client.basal_metabolism)
  @physical_age.set({}, @client.physical_age)
  @skeletal_muscle_level.set({}, @client.skeletal_muscle_level)
  @bone_level.set({}, @client.bone_level)
  @visceral_fat_level.set({}, @client.visceral_fat_level)
  @water_content.set({}, @client.water_content)
end

run ->(env) {
  if env['PATH_INFO'] == '/metrics'
    collect()
    [
      200,
      { 'Content-Type' => format::CONTENT_TYPE },
      [format.marshal(prometheus)],
    ]
  else
    [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
  end
}
