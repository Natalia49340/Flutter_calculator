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
      'Cale': 39.3701,
      'Stopy': 3.28084,
      'Mile': 0.000621371,
    },
    'Objętość': {
      'Litr': 1,
      'Mililitr': 1000,
      'Cm sześcienny': 1000,
      'Metr sześcienny': 0.001,
    },
    'Temperatura': {
      'Celsjusz': 1,
      'Fahrenheit': 33.8,
      'Kelwin': 274.15,
    },
    'Czas': {
      'Milisekunda': 0.001,
      'Sekunda': 1,
      'Minuta': 0.0166667,
      'Godzina': 0.000277778,
      'Dzień': 1.15741e-5,
      'Tydzień': 1.65344e-6,
    },
    'Powierzchnia': {
      'Akr': 0.000247105,
      'Hektar': 1e-4,
      'Cm kwadratowy': 10000,
      'Metr kwadratowy': 1,
    },
    'Szybkość': {
      'Metr na sekundę': 1,
      'Metr na godzinę': 3600,
      'Kilometr na sekundę': 0.001,
      'Kilometr na godzinę': 3.6,
    },
  };

  List<String> categories = ['Masa', 'Długość', 'Objętość', 'Temperatura', 'Czas', 'Powierzchnia', 'Szybkość'];

  List<String> units() {
    return conversionData[selectedCategory]!.keys.toList();
  }

  void convert() {
    setState(() {
      convertedValues = {};
      if (sourceUnit.isNotEmpty && targetUnit.isNotEmpty) {
        double sourceMultiplier = conversionData[selectedCategory]![sourceUnit]!;
        double targetMultiplier = conversionData[selectedCategory]![targetUnit]!;
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
          mainAxisAlignment: MainAxisAlignment.start, // Changed to start
          children: [
            SizedBox(height: 40), // Pusty kontener
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categories
                    .map((String category) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = category;
                                sourceUnit = units().first;
                                targetUnit = units().last;
                                convert();
                              });
                            },
                            child: Text(category),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                selectedCategory == category ? Color.fromARGB(255, 169, 148, 206) : const Color.fromARGB(255, 253, 253, 253),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String unit in units())
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sourceUnit = unit;
                          convert();
                        });
                      },
                      child: Text(unit),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          sourceUnit == unit ? Color.fromARGB(255, 169, 148, 206) : const Color.fromARGB(255, 253, 253, 253),
                        ),
                      ),
                    ),
                  SizedBox(width: 20),
                  for (String unit in units())
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          targetUnit = unit;
                          convert();
                        });
                      },
                      child: Text(unit),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          targetUnit == unit ? Color.fromARGB(255, 169, 148, 206) : const Color.fromARGB(255, 253, 253, 253),
                        ),
                      ),
                    ),
                ],
              ),
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
                  style: TextStyle(fontSize: 20, fontFamily: 'Nazwa_Czcionki'), // Dodane fontFamily
                ),
          ],
        ),
      ),
    );
  }
}
