/*
Os imports aplicam a importação de classes que facilitam o 
desenvolvimento da aplicação: A classe material.dart aplica
os widgets; elements e Render Objects para o Android 
(material design)
A classe http.dart é utilizada para aplicarmos os métodos para
transmissão de dados utilizando o portocolo http e https
*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*
 A função main() é padrão em linguagens derivadas da C, nesta
 função é adiciona a execução inicial de todo aplicativo, é o
ponto de partida. A função runApp() invoca uma classe que será
a primeira a ser executada. Só pode haver uma função main() em
todo o projeto, é como Highlander: só pode haver um
*/
void main() {
  runApp(Domotica());
}
/*
 A classe Domotica está herdando características e recursos da
classe StatelessWidget. Esta superclasse já está definida pelo
framework Flutter, ela define padrões como o método build() que
deve ser, obrigatóriamente, implementado em toda aplicação que 
tiver uma classe herdando de StatelessWidget. Widgets referem-se
a qualquer componente Flutter. Componentes Stateless não possuem
estado, portanto ao herdar da classe StatelessWidget devemos 
definir no método build apenas componentes estáticos.
*/
class Domotica extends StatelessWidget {

  /*
    O método obrigatório build precisa do parâmetro de contexto, o
    context. Nele retornamos o classe MaterialApp que mantém 
    toda estrutura e conteúdo do App
  */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // A propriedade debugShowCheckedModeBanner habilita ou desabilita
      // o banner "debug" que fica no canto superior direito da tela
      debugShowCheckedModeBanner: false,
      // A propriedade home: define a estrutura principal, sendo
      // que Scaffond é a estrutura básica para formar a tela
      home: Scaffold(
        // Barra superior do aplicativo com título e cor de fundo
        appBar: AppBar(
          title: Text(' CONTROLE DOMÉSTICO FATEC'),
          backgroundColor: Colors.blue,
        ),
        // A propriedade body; pertence ao Scaffold, assim como a
        // appBar acima, e nela definimos os arranjos do corpo da
        // tela, o que vai logo abaixo do appBar, que neste caso
        // ficará centralizado
        body: Center(
          // Definição do arranjo coluna que posiciona um widget
          // acima do outro
          child: Column(
            //a propriedade MainAxisAlignment define o alinhamento
            // principal, que se tratando de coluna o eixo (Axis)
            // principal é o vertical. O valor spaceBetween define
            // um espaço vertical proporcional entre os widget
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // elemento para alocar mais de um componente, perceba
            // que os colchetes são representações de conjuntos na
            // programação, portanto os componentes estarão entre
            // os colchetes do children. Exemplo: 
            // children [ compon1(), compon2(), ..., componN()]
            children: [

              // Componente customizado do ElevatedButton, ele
              // exige a definição de 3 propriedades: text, color e
              // command
              CustomButton(
                text: 'ACENDER LUZ',
                color: Colors.red,
                command: 'ligaluz',
              ),
              CustomButton(
                text: 'APAGAR LUZ',
                color: Colors.blue,
                command: 'desligaluz',
              ),
              CustomButton(
                text: 'LIGAR TV',
                color: Colors.orange,
                command: 'ligatv',
              ),
              CustomButton(
                text: 'DESLIGAR TV',
                color: Colors.green,
                command: 'desligartv',
              ),
              CustomButton(
                text: 'ABRIR PORTÃO',
                color: Colors.yellow,
                command: 'abrir',
              ),
              CustomButton(
                text: 'FECHAR PORTÃO',
                color: Colors.white,
                command: 'fechar',
              ),
            ], // fim do elemento children
          ),
        ),
      ),
    );
  } // fim do método build
} // fim da classe Domotica

/*
 Classe CustomButton herda de StatefulWidget. A superclasse 
 provê a definição de estados para os componentes e elementos
 definidos na CustomButton
*/
class CustomButton extends StatefulWidget {
  //Declaração das propriedades text; color e command
  final String text;
  final Color color;
  final String command;

  // Construtor define que os atributos text; color e command
  // são obrigatórios
  CustomButton({required this.text, required this.color, 
                  required this.command});

  // criando a instância da classe privada _CustomButtonState
  // esta classe irá controlar o estado dos componentes nela
  // definidos
  @override
  _CustomButtonState createState() => _CustomButtonState();
} // fim da classe CustomButton

// a classe privada _CustomButtonState está herdando da classe
// State, que aplica o controle de estado para a classe que 
// estiver entre <>
class _CustomButtonState extends State<CustomButton> {
  String result = ''; // declaração da variável result

  // ´método enviarComando() recebe por parâmetro o comando e 
  // deve estar sincronizado com outro recurso. 
  void enviarComando(String command) async {
    // Declaração das variáveis serverUrl que mantém o 
    // o link (não a Zelda) do servidor
    final String serverUrl = 'domotica.fatecitapira.com.br';
    //A variável path mantém o caminho até o script que está
    // no servidor, este script deve gerenciar o controle dos
    // comandos
    final String path = '/projdomotica/comandoscasa.php';
    // A variável url armazena os parâmetros: o endereço do
    // servidor (ServerUrl), o caminho até o script para os 
    // comandos (path) e o comando.
    final url = Uri.https(serverUrl, path, 
      {'command': command});

  // estrutura para tratamento de exceções try...catch para 
  // exeções ocasionadas pelo protocolo http
    try {
      // response recebe o retorno do servidor quando for enviado o
      // comando. A variável url passa o servidor, o caminho para
      // o script e o comando. a função await aguarda a resposta do
      // servidor
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          // se o comando foi enviado corretamente a variável
          // result recebe o conteúdo em body do response, que
          // tem a url do servidor, o caminho até o script e o 
          // comando. Este processo é apenas para nosso teste,
          // depois transformaremos em um snackbar "Comando X enviado"
          result = response.body;
        });
      } else {
        setState(() {
          // se chegar aqui deu erro portanto guardaremos na variável
          // result a mensagem de erro, para mostrarmos em nosso teste
          // depois iremos alterar para snackbar
          result = 'Erro ao obter dados: ' +
                '${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        // se chegar aqui já é exceção dada pelo protocolo HTTP
        result = 'Erro: $e';
      });
    }
  }

// Método build para a classe do botão
  @override
  Widget build(BuildContext context) {
    // define o arranjo Coluna
    return Column(
      // conjunto de componentes do children
      children: [
        // O Widget ElevatedButton, ele possui mudança de 
        // estado, por isso está aqui.
        ElevatedButton(
          // a propriedade style, para a estilização do botão
          style: ButtonStyle(
            //Define a cor de fundo do botão
            backgroundColor: 
            //permite a sobreposição da cor para o botão, que
            // e definida de fato no CustomButton, perceba que
            // o color do widget é exatamente o color definido
            // no customButton
            WidgetStateProperty.all<Color>(widget.color),
            // para sobrepor a cor precisamos implementar a 
            // a propriedade overlayColor, nela que terá a
            // definição do estado da cor
            overlayColor: 
            WidgetStateProperty.resolveWith<Color>(
              // Ajustando o estado para...
              (Set<WidgetState> states) {
                // se passar o mouse por cima ajusta para a cor
                // black12
                if (states.contains(WidgetState.hovered)) {
                  return Colors.black12;
                }
                // retorna a cor definida no customButtom
                return widget.color;
              },
            ),
          ),
          // define o texto do botão
          child: Text(
            // o texto definido no CustomButton passa para 
            // widget.text
            widget.text,
            // o tamanho e a cor do texto, ou seja, todos 
            // os botões terão o tamanho da fonte 20 e a 
            // cor branca
            style: TextStyle(fontSize: 20.0, 
                    color: Colors.white),
          ),
          // define o método que será invocado quando pressionar
          // o botão
          onPressed: () {
            // invoca o método enviarComando, passando por parâmetro
            // o comando definido no CustomButton
            enviarComando(widget.command);
          },
        ),
        SizedBox(height: 10),
        Text(
          result,
          style: TextStyle(fontSize: 16, 
          color: Colors.black),
        ),
      ],
    );
  }
}
