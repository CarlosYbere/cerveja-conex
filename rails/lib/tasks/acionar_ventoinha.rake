namespace :acionar_ventoinha do
  desc "atualiza a ventoinha em caso de temperatura acima"
  task corrigir: :enviroment do
    require 'nokogiri'
    if Temp.to_f > $temperatura_maxima
      port_str = `ls /dev`.split("\n").grep(/ACM/i).map{|d| "/dev/#{d}"}.last
      baud_rate = 115200
      serialport = Serial.new port_str, baud_rate
      leitura = serialport.read 3000
      xml = Nokogiri::XML DataController.search_pattern leitura
      Temp = (xml.css "Temp").text
      IN1 = (xml.css "IN1").text
      IN2 = (xml.css "IN2").text
      if IN1 == "0"
        serialport.write "m"
      end
      if IN2 == "0"
        serialport.write "n"
      end
    end
  end
end
