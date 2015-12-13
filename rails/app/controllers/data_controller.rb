class DataController < ApplicationController
	require 'rubyserial'
	require 'nokogiri'
	def sensors

		port_str = `ls /dev`.split("\n").grep(/usb|ACM/i).map{|d| "/dev/#{d}"}.first
		baud_rate = 115200
		serialport = Serial.new port_str, baud_rate

		#aqui eu vejo a luz'
		@lightstatus = true
		@lightonoff = true #aqui eu coloc

		leitura = serialport.read 300

		beginPattern = "<SerialArduino>"
		beginIndex = leitura.index beginPattern
		leitura = leitura[beginIndex..leitura.length]

		endPattern = "</SerialArduino>"
		endSize = endPattern.length
		endIndex = leitura.index endPattern

		@XML = leitura[0..(endIndex+endSize)]

		xml = Nokogiri::XML @XML

		@Amp = (xml.css "Amp").text
		@Pot = (xml.css "Pot").text
		@KWhdia = (xml.css "KWhdia").text
		@KWhmes = (xml.css "KWhmes").text
		@Conta = (xml.css "Conta").text

		data = SensorData.new
		data.amp = @Amp.to_f
		data.pot = @Pot.to_f
		data.kwhdia = @KWhdia.to_f
		data.kwhmes = @KWhmes.to_f
		data.conta = @Conta.to_f
		data.save

		if params["todo"]=="turnoff"
				serialport.write "mn"
				puts "desligando"
		elsif params["todo"]=="turnon"
				serialport.write "mn"
				puts "ligando"
		end
		serialport.close
		respond_to do |format|
			format.xml { render xml: @XML }
			format.html
		end
	end

end
