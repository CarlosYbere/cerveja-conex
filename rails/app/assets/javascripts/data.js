function updateInterface(xml){//função para atualizar os elementos na tela
  $("#Amp").html($(xml).find("Amp").text());// # é símbolo pra pegar id
  $("#Pot").html($(xml).find("Pot").text());// .html troca o conteúdo do elemento
  $("#KWhmes").html($(xml).find("KWhmes").text());//.find procura o elemento interno
  $("#KWhdia").html($(xml).find("KWhdia").text());//se não tiver nem . e nem # ele procura pela tag
  $("#Conta").html($(xml).find("Conta").text());//.text() retorna o conteúdo
  $("#Temp").html($(xml).find("Temp").text());
  if($(xml).find("IN1").text()=="1"){
    $("#fan-button-m").addClass('down');
  }else {
    $("#fan-button-m").removeClass('down');
  }
  if($(xml).find("IN2").text()=="1"){
    $("#fan-button-n").addClass('down');
  }else {
    $("#fan-button-n").removeClass('down');
  }
}
function getData(){//pegar os dados no servidor
  var options = {//declara as diretrizres de ação na requisição do ajax
    success: updateInterface,//caso sucesso, atualiza os dados na tela'
    error: function( jqXHR, textStatus, errorThrown){//caso erro, imprime no console'
      console.error(errorThrown);
    }
  };
  jQuery.ajax("/sensores.xml",options);//chama o ajax com as opções declaradas acima
}
setInterval(getData,1000);//faz com que a função seja executada a cada xxx milisegundos
function command(comando){
  jQuery.ajax("/sensores?comando="+comando);
}
function tempMax(){
    jQuery.ajax("/sensores?temp-max="+$("#temp-max-field").val());
}
