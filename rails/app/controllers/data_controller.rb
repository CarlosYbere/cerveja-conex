class DataController < ApplicationController
	require 'rubyserial'
	require 'nokogiri'

	def self.search_pattern raw_string
		beginPattern = "<SerialArduino>"
		beginIndex = raw_string.index(beginPattern)
		puts "beginIndex:"
		puts beginIndex
		raw_string = raw_string[beginIndex..raw_string.length]

		endPattern = "</SerialArduino>"
		endSize = endPattern.length
		endIndex = raw_string.index endPattern

		return raw_string[0..(endIndex+endSize)]
	end
	def create_sensor_data	 amp,pot,kWhdia,kWhmes,conta
		sensorData = SensorData.new
		sensorData.amp = amp.to_f
		sensorData.pot = pot.to_f
		sensorData.kwhdia = kWhdia.to_f
		sensorData.kwhmes = kWhmes.to_f
		sensorData.conta = conta.to_f
		sensorData.save
	end
	def sensors
		#começa com valor padram sem nada
		@XML =@Amp =@Pot = @KWhdia = @KWhmes = @Conta =@Temp =""
		port_str = `ls /dev`.split("\n").grep(/ACM/i).map{|d| "/dev/#{d}"}.last
		baud_rate = 115200
		puts "Abrindo a porta "+port_str+"com frequência "+baud_rate.to_s
		if port_str == nil
			@error = "Sem portas disponíveis"
		else
			serialport = Serial.new port_str, baud_rate
			if !params["comando"]
				params["comando"]="g"
			end
			serialport.write params["comando"]
			sleep 0.5
			if params["comando"].include? "g" #não é uma solução legal...ficaria melhor se usasse rake tasks
				leitura = serialport.read 3000
				if leitura!=""
					puts "leitura crua:("+leitura+")"
					@XML = DataController.search_pattern leitura

					xml = Nokogiri::XML @XML

					@Amp = (xml.css "Amp").text
					@Pot = (xml.css "Pot").text
					@KWhdia = (xml.css "KWhdia").text
					@KWhmes = (xml.css "KWhmes").text
					@Conta = (xml.css "Conta").text
					@Temp = (xml.css "Temp").text
					@IN1 = (xml.css "IN1").text
					@IN2 = (xml.css "IN2").text
					puts "temperatura: #{@Temp}"
					puts "in1: #{@IN1}"
					puts "in2: #{@IN2}"

					create_sensor_data @Amp,@Pot,@KWhdia,@KWhmes,@Conta

				else
					puts @error="leitura não encotrada"
				end
				respond_to do |format|
					format.xml { render xml: @XML }
					format.html
				end
			end
				serialport.close
		end
	end
end
