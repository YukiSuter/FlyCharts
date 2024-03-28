import 'package:flutter/material.dart';
import 'package:flycharts/widgets/bottomBar.dart';
import 'package:flycharts/widgets/cardButton.dart';
import 'package:flycharts/widgets/sideBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  sideBar(),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 60, bottom: 60, left: 60, right: 60),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Welcome to FlyCharts!",
                                  textScaler: TextScaler.linear(4),
                                ),
                              ),
                              Container(
                                width: 800,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      color: Color.fromARGB(26, 0, 0, 0),
                                      width: 1),
                                  color: Color.fromARGB(255, 246, 246, 246),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(50),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Getting Started",
                                        textScaler: TextScaler.linear(2),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(30),
                                            child: cardButton(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                borderColor:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                borderRadius: 5,
                                                text: "Create New Flightplan",
                                                height: 200,
                                                width: 150,
                                                icon: Icons.add,
                                                textScaleFactor: 1.3,
                                                iconSize: 60),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(30),
                                            child: cardButton(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                borderColor:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                borderRadius: 5,
                                                text:
                                                    "Load Simbrief Flightplan",
                                                height: 200,
                                                width: 150,
                                                icon: Icons.file_copy,
                                                textScaleFactor: 1.3,
                                                iconSize: 60),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(30),
                                            child: cardButton(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                borderColor:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                borderRadius: 5,
                                                text: "Charts by ICAO",
                                                height: 200,
                                                width: 150,
                                                icon: Icons.map,
                                                textScaleFactor: 1.3,
                                                iconSize: 60),
                                          ),
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
                    ),
                  )
                ],
              ),
            ),
            bottomBar()
          ],
        ),
      ),
    );
  }
}
