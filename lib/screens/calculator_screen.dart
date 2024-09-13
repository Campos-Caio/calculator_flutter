import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; 
  String operand = ""; 
  String number2 = ""; 

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // pega o tamanho da tela

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Visor
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            // Buttons
            Wrap(
              // Mapeia os botoes e gera um botao para cada valor baseado no espaco de tela disponivel
              children: Buttons.buttonValues
                  .map<Widget>((value) => SizedBox(
                      width: value == Buttons.n0 ? screenSize.width / 2 : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(Object value) { // builda cada botao da lista baseado no value 
    bool isIcon = value is IconData;
    
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () {},
          child: Center(
            child: isIcon
                ? Icon(
                    value as IconData, // Exibe o ícone
                    color: Colors.white,
                  )
                : Text(
                    value.toString(), // Exibe o texto
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Color getButtonColor(value){ //Retorna a cor do botao baseado no valor do botao
    return [Buttons.deleteIcon, Buttons.clr].contains(value)
        ? Colors.blueGrey
        : [
            Buttons.divide,
            Buttons.multiply,
            Buttons.add,
            Buttons.subtract,
            Buttons.calculate,
            Buttons.dot,
            Buttons.per
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
