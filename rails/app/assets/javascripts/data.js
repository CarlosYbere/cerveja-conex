unction updateInterface(xml){//função para atualizar os elementos na tela
  $("#Amp").html($(xml).find("Amp").text());// # é símbolo pra pegar id
  $("#Pot").html($(xml).find("Pot").text());// .html troca o conteúdo do elemento
  $("#KWhmes").html($(xml).find("KWhmes").text());//.find procura o elemento interno
  $("#KWhdia").html($(xml).find("KWhdia").text());//se não tiver nem . e nem # ele procura pela tag
  $("#Conta").html($(xml).find("Conta").text());//.text() retorna o conteúdo
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
