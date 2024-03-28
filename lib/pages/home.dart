import 'package:flutter/material.dart';
import 'package:flycharts/pages/chartSearch.dart';
import 'package:flycharts/scaling.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/cardButton.dart';
import 'package:flycharts/widgets/sideBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double calcSF = scaleFactor(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(60 * calcSF),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0 * calcSF),
                child: Text(
                  "Welcome to FlyCharts!",
                  textScaler: TextScaler.linear(4 * calcSF),
                ),
              ),
              Container(
                width: 800 * calcSF,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border:
                      Border.all(color: Color.fromARGB(26, 0, 0, 0), width: 1),
                  color: Color.fromARGB(255, 246, 246, 246),
                ),
                child: Padding(
                  padding: EdgeInsets.all(50 * calcSF),
                  child: Column(
                    children: [
                      Text(
                        "Getting Started",
                        textScaler: TextScaler.linear(2 * calcSF),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30 * calcSF),
                            child: cardButton(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                borderColor: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius: 5 * calcSF,
                                text: "Create New Flightplan",
                                height: 200 * calcSF,
                                width: 150 * calcSF,
                                icon: Icons.add,
                                textScaleFactor: 1.3 * calcSF,
                                iconSize: 60 * calcSF),
                          ),
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: cardButton(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                borderColor: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius: 5 * calcSF,
                                text: "Load Simbrief Flightplan",
                                height: 200 * calcSF,
                                width: 150 * calcSF,
                                icon: Icons.file_copy,
                                textScaleFactor: 1.3 * calcSF,
                                iconSize: 60 * calcSF),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => chartSearch()));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(30 * calcSF),
                              child: cardButton(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: 5 * calcSF,
                                  text: "Charts by ICAO",
                                  height: 200 * calcSF,
                                  width: 150 * calcSF,
                                  icon: Icons.map,
                                  textScaleFactor: 1.3 * calcSF,
                                  iconSize: 60 * calcSF),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
