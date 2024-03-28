import 'package:flutter/material.dart';
import 'package:flycharts/pages/home.dart';
import 'package:flycharts/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key, required this.navKey});

  final GlobalKey<NavigatorState> navKey;
  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  SharedPreferences? _prefs = null;
  late final _prefsFuture =
      SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  Widget build(
    BuildContext context,
  ) {
    return FutureBuilder(
      future: _prefsFuture,
      builder: (context, snapshot) {
        print("prefs: " + _prefs.toString());
        if (_prefs == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(right: 1),
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: activeTheme(_prefs!, "border")!.withOpacity(0.1),
                      width: 2)),
              color: activeTheme(_prefs!, "secondaryBackground")!,
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
                            color: activeTheme(_prefs!, "sideBarButtons")!,
                            size: 35,
                            semanticLabel: 'menu',
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            widget.navKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          },
                          icon: Icon(
                            Icons.home,
                            color: activeTheme(_prefs!, "sideBarButtons")!,
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
                            color: activeTheme(_prefs!, "sideBarButtons")!,
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
                            color: activeTheme(_prefs!, "sideBarButtons")!,
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

        return CircularProgressIndicator();
      },
    );
  }
}
