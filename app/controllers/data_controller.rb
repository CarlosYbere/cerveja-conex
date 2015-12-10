class DataController < ApplicationController
	def light
		#aqui eu vejo a luz'
		@lightstatus = true
		@lightonoff = true #aqui eu coloc
		respond_to do |format|
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
