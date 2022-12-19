import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String equation = '0';
  String result = '0';
  Map<String, String> operators = <String, String>{
    '÷': '/',
    '×': '*',
    '−': '-',
    '+': '+',
  };

  void evaluateEquation() {
    try {
      Expression exp;
      double res;

      exp = Parser().parse(
        operators.entries.fold(
          equation,
          (String prev, MapEntry<String, String> elem) => prev.replaceAll(
            elem.key,
            elem.value,
          ),
        ),
      );

      res = double.parse(exp.evaluate(EvaluationType.REAL, ContextModel()).toString());

      result = double.parse(res.toString()) == int.parse(res.toStringAsFixed(0))
          ? res.toStringAsFixed(0)
          : res.toStringAsFixed(4);
    } catch (e) {
      result = 'Error';
    }
  }

  buttonPressed(String text) {
    setState(() {
      if (text == 'c') {
        equation = result = '0';
      } else {
        if (text == '=') {
          equation = result;
        } else if (text == '<') {
          if (equation.length > 1)
            equation = equation.substring(0, equation.length - 1);
          else
            equation = '0';
        } else if (text == '+−') {
          if (equation != '0') {
            double i = double.parse(result) * (-1);
            equation = i.toString();
          }
          if (double.parse(equation) == double.parse(equation.substring(0, equation.length - 2))) {
            equation = equation.substring(0, equation.length - 2);
          }
        } else if (text == 'x²') {
          double i = double.parse(result) * double.parse(result);
          equation = i.toString();
          if (double.parse(equation) == double.parse(equation.substring(0, equation.length - 2))) {
            equation = equation.substring(0, equation.length - 2);
          }
        } else {
          if (equation == '0' && text != '.') equation = '';
          equation += text;
        }
      }
      if (equation == '-') equation = result = '−';

      if (!operators.containsKey(equation.substring(equation.length - 1))) evaluateEquation();
    });
  }

  Widget showResult() {
    var value = num.tryParse(equation);
    var value2 = num.tryParse(equation.replaceFirst('−', '-'));
    if (value == null && value2 == null && result != '0') {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
        alignment: Alignment.bottomRight,
        child: Text(
          '= ' + result,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: MediaQuery.of(context).size.height * 0.05,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }
    return Container();
  }

  Widget button(text, theme) {
    dynamic color;
    if (theme == 'number') color = Colors.grey[700];
    if (theme == 'main') color = Colors.orange[400];
    if (theme == 'other') color = Colors.grey[400];
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: FlatButton(
        color: color,
        shape: CircleBorder(),
        child: Text(
          text,
          style: TextStyle(
            color: theme == 'other' ? Colors.black87 : Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.normal,
          ),
        ),
        onPressed: () => buttonPressed(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black87,
        child: Column(
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      equation,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.08,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  showResult(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      button('c', 'other'),
                      button('7', 'number'),
                      button('4', 'number'),
                      button('1', 'number'),
                      button('.', 'other'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      button('x²', 'other'),
                      button('8', 'number'),
                      button('5', 'number'),
                      button('2', 'number'),
                      button('0', 'number'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      button('+−', 'other'),
                      button('9', 'number'),
                      button('6', 'number'),
                      button('3', 'number'),
                      button('<', 'other'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      button('÷', 'main'),
                      button('×', 'main'),
                      button('−', 'main'),
                      button('+', 'main'),
                      button('=', 'main'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
