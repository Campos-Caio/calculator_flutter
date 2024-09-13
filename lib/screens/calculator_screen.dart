import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String first_number = "";
  String operand = "";
  String second_number = "";

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
                    "$first_number$operand$second_number".isEmpty
                        ? "0"
                        : "$first_number$operand$second_number",
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
                      width: value == Buttons.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(Object value) {
    // builda cada botao da lista baseado no value
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
          onTap: () => onButtonClick(value),
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

  void onButtonClick(value) {
    if (value == Buttons.deleteIcon) {
      delete();
      return;
    }
    if (value == Buttons.clr) {
      clearAll();
      return;
    }
    if (value == Buttons.per) {
      convertToPercentage();
      return;
    }
    if (value == Buttons.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  void calculate() {
    if (first_number.isEmpty) return;
    if (operand.isEmpty) return;
    if (second_number.isEmpty) return;

    double num1 = double.parse(first_number);
    double num2 = double.parse(second_number);
    var result = 0.0;

    switch (operand) {
      case Buttons.add:
        result = num1 + num2;
        break;
      case Buttons.subtract:
        result = num1 - num2;
        break;
      case Buttons.multiply:
        result = num1 * num2;
        break;
      case Buttons.divide:
        result = num1 / num2;
        break;
      default:
        return;
    }

    setState(() {
      first_number = "$result";

      // Remove ".0" do final se for número inteiro
      if (first_number.endsWith('.0')) {
        first_number = first_number.substring(0, first_number.length - 2);
      }

      operand = ""; // Reseta o operador
      second_number = ""; // Reseta o segundo número
    });
  }

  void convertToPercentage() {
    if (first_number.isNotEmpty &&
        operand.isNotEmpty &&
        second_number.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(first_number);
    setState(() {
      first_number = (double.parse(first_number) / 100).toString();
      operand = "";
      second_number = "";
    });
  }

  void clearAll() {
    setState(() {
      first_number = "";
      second_number = "";
      operand = "";
    });
  }

  void delete() {
    if (second_number.isNotEmpty) {
      second_number = second_number.substring(0, second_number.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (first_number.isNotEmpty) {
      first_number = first_number.substring(0, first_number.length - 1);
    }

    setState(() {});
  }

  void appendValue(value) {
    // verifica se o operador foi pressionado e nao o "."
    if (value != Buttons.dot && int.tryParse(value) == null) {
      // operador selecionado
      if (operand.isNotEmpty && second_number.isNotEmpty) {
        calculate(); 
      }
      operand = value;
    } // atribui o valor ao primeiro numero
    else if (first_number.isEmpty || operand.isEmpty) {
      // verifica se o valor eh "."
      if (value == Buttons.dot && first_number.contains(Buttons.dot)) return;
      if (value == Buttons.dot &&
          (first_number.isEmpty || first_number == Buttons.n0)) {
        value = "0.";
      }
      first_number += value;
    } // atribui o valor ao segundo numero
    else if (second_number.isEmpty || operand.isNotEmpty) {
      // verifica se o valor eh "."
      if (value == Buttons.dot && second_number.contains(Buttons.dot)) return;
      if (value == Buttons.dot &&
          (second_number.isEmpty || second_number == Buttons.n0)) {
        value = "0.";
      }
      second_number += value;
    }

    setState(() {});
  }

  Color getButtonColor(value) {
    //Retorna a cor do botao baseado no valor do botao
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
