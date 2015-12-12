class DataController < ApplicationController
	require 'rubyserial'
	require 'nokogiri'
	def light

		port_str = `ls /dev`.split("\n").grep(/usb|ACM/i).map{|d| "/dev/#{d}"}[0] #may be different for you
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

		if params["action"]=="turnoff"
				serialport.write "d"
		elsif params["action"]=="turnon"
				serialport.write "l"
		end


		respond_to do |format|
			format.xml { render xml: @XML }
			format.js
			format.html
		end
	end
	def sensors
		#aqui eu me comunico com os sensores...
		#criando variavel global com @
		@temperature = 40
	end
	def multimedia
		@link = "http.xxx.x.xx.x.xxx"
	end
	def plot
		@valor = 5
	end
end
