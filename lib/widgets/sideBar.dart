import 'package:flutter/material.dart';
import 'package:flycharts/pages/home.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key, required this.navKey});

  final GlobalKey<NavigatorState> navKey;
  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 1),
      decoration: BoxDecoration(
        border: Border(
            right: BorderSide(color: Color.fromARGB(26, 0, 0, 0), width: 2)),
        color: Color.fromARGB(255, 246, 246, 246),
      ),
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      color: const Color.fromARGB(255, 48, 48, 48),
                      size: 35,
                      semanticLabel: 'menu',
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      widget.navKey.currentState!.push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(
                      Icons.home,
                      color: const Color.fromARGB(255, 48, 48, 48),
                      size: 35,
                      semanticLabel: 'Home',
                    ),
                  )),
            ],
          ),
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 48, 48, 48),
                      size: 35,
                      semanticLabel: 'search',
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      color: const Color.fromARGB(255, 48, 48, 48),
                      size: 35,
                      semanticLabel: 'settings',
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
