import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final TextEditingController feresController = TextEditingController();
  final TextEditingController rideController = TextEditingController();
  double result = 0;
  bool _isAboutExpanded = false;
  bool _isHelpExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Tax Calculator'),
        actions: [
          _buildExpandableButton(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: feresController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Yearly Feres Income ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: rideController,
                decoration: InputDecoration(
                  hintText: 'Enter your Yearly Ride Cridit ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  calculateResult();
                },
                child: Text('Calculate'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Your Yearly Tax is: ${result.toStringAsFixed(2)} Birr',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateResult() {
    double feresValue = double.tryParse(feresController.text) ?? 0.0;
    double rideValue = double.tryParse(rideController.text) ?? 0.0;

    double rideCalculation = rideValue * 100;
    double rideCalc= rideCalculation / 12;
    double totalCalculation = (feresValue + rideCalc) * 0.3;

    double finalResult = 0;

    if (totalCalculation <= 7200) {
      finalResult = totalCalculation;
    } else if (totalCalculation <= 19800) {
      finalResult = totalCalculation * 0.1 - 720;
    } else if (totalCalculation <= 38400) {
      finalResult = totalCalculation * 0.15 - 1710;
    } else if (totalCalculation <= 63000) {
      finalResult = totalCalculation * 0.20 - 3630;
    } else if (totalCalculation <= 93600) {
      finalResult = totalCalculation * 0.25 - 6780;
    } else if (totalCalculation <= 130800) {
      finalResult = totalCalculation * 0.30 - 11460;
    } else {
      finalResult = totalCalculation * 0.35 - 18000;
    }

    setState(() {
      result = finalResult;
    });
  }

  Widget _buildExpandableButton() {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      if (index == 0) {
                        _isAboutExpanded = !isExpanded;
                      } else if (index == 1) {
                        _isHelpExpanded = !isExpanded;
                      }
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About'),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tax Calculator v1.0'),
                            Text('Developed by Adam Debalke'),
                            SizedBox(height: 10.0),
                            TextButton(
                              onPressed: () {
                                // Add your LinkedIn profile URL here
                                String linkedInURL = 'www.linkedin.com/in/adam-debalke-1b2b6518a';
                                // Open the LinkedIn profile in the browser
                                launchURL(linkedInURL);
                              },
                              child: Text('LinkedIn Profile'),
                            ),
                          ],
                        ),
                      ),
                      isExpanded: _isAboutExpanded,
                    ),
                  
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

 void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}