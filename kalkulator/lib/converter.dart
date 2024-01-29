import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String selectedCategory = 'Masa';
  String sourceUnit = '';
  String targetUnit = '';
  double inputValue = 0.0;
  Map<String, double> convertedValues = {};

  Map<String, Map<String, double>> conversionData = {
    'Masa': {
      'Gram': 1,
      'Kilogram': 0.001,
    },
    'Długość': {
      'Metr': 1,
      'Kilometr': 0.001,
      'Centymetr': 100,
      'Milimetr': 1000,
    },
  };

  List<String> categories = ['Masa', 'Długość'];

  List<String> units() {
    return conversionData[selectedCategory]!.keys.toList();
  }

  void convert() {
    setState(() {
      convertedValues = {};
      if (sourceUnit.isNotEmpty && targetUnit.isNotEmpty) {
        double sourceMultiplier =
            conversionData[selectedCategory]![sourceUnit]!;
        double targetMultiplier =
            conversionData[selectedCategory]![targetUnit]!;
        double conversionFactor = targetMultiplier / sourceMultiplier;
        convertedValues[targetUnit] = inputValue * conversionFactor;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    sourceUnit = units().first;
    targetUnit = units().last;
    convert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 192, 175, 219),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  sourceUnit = units().first;
                  targetUnit = units().last;
                  convert();
                });
              },
              items: categories
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: sourceUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        sourceUnit = newValue!;
                        convert();
                      });
                    },
                    items: units()
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<String>(
                    value: targetUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        targetUnit = newValue!;
                        convert();
                      });
                    },
                    items: units()
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0.0;
                  convert();
                });
              },
              decoration: InputDecoration(
                labelText: 'Wprowadź wartość w ${sourceUnit.toLowerCase()}',
              ),
            ),
            SizedBox(height: 20),
            for (String unit in units())
              if (convertedValues[unit] != null)
                Text(
                  '$unit: ${convertedValues[unit]}',
                  style: TextStyle(fontSize: 20),
                ),
          ],
        ),
      ),
    );
  }
}
