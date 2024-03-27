import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

String link_root = "https://nats-uk.ead-it.com/cms-nats/opencms/en/Publications/AIP/Current-AIRAC/html/eAIP/EG-AD-2.";
String link_suffix = "-en-GB.html";

String file_root = "https://nats-uk.ead-it.com/cms-nats/export/sites/default/en/Publications/AIP/Current-AIRAC/";

EG(airfield) async {
  print("SEARCHING FOR UK AERODROME USING API");
  String eAIP = link_root + airfield + link_suffix;
  var ADName;

  final response = await http.get(Uri.parse(eAIP));

  Map<String, Map<String, dynamic>> charts = {};

  if (response.statusCode == 200) {
    var document = parse(response.body);
    String chartsLoc = airfield + "-AD-2\u002E24";
    print(chartsLoc);
    var chartsContainer = document.querySelector('[id="' + chartsLoc + '"]');


    if (chartsContainer != null) {
      var chartsTable = chartsContainer.getElementsByTagName('table')[0];

      print(chartsTable.children[0].children.length);

      for (var i = 0; i <= chartsTable.children[0].children.length/2; i++) {
        var container =  chartsTable.children[0].children[i].children[0].children[0];
        print("localname:");
        print(container.localName);

        if (container.localName == "p") {
          var nextContainer = chartsTable.children[0].children[i + 1].children[0].children[0];

          var code = nextContainer.innerHtml.replaceAll("AD&nbsp;2." + airfield + "-","");
          print(code);
          
          var key = container.innerHtml;
          if (container.children.length != 0) {
            key = container.children[0].innerHtml;
          }

          if (code[0].toString() == "5" || code[0].toString() == "3" || code[0].toString() == "4") {
            if (charts.containsKey("GEN") == false) {
              charts.putIfAbsent("GEN", () => {});
            }

            charts["GEN"]?.putIfAbsent(key, () => {"detail": code, "link": eAIP + "/../" + nextContainer.attributes["href"]!});
          }

          if (code[0].toString() == "2") {
            if (charts.containsKey("TAXI") == false) {
              charts.putIfAbsent("TAXI", () => {});
            }

            charts["TAXI"]?.putIfAbsent(key, () => {"detail": code, "link": eAIP + "/../" + nextContainer.attributes["href"]!});
          }

          if (code[0].toString() == "6") {
            if (charts.containsKey("SID") == false) {
              charts.putIfAbsent("SID", () => {});
            }

            charts["SID"]?.putIfAbsent(key, () => {"detail": code, "link": eAIP + "/../" + nextContainer.attributes["href"]!});
          }

          if (code[0].toString() == "7") {
            if (charts.containsKey("STAR") == false) {
              charts.putIfAbsent("STAR", () => {});
            }

            charts["STAR"]?.putIfAbsent(key, () => {"detail": code, "link": eAIP + "/../" + nextContainer.attributes["href"]!});
          }

          if (code[0].toString() == "8") {
            if (charts.containsKey("APPR") == false) {
              charts.putIfAbsent("APPR", () => {});
            }

            charts["APPR"]?.putIfAbsent(key, () => {"detail": code, "link": eAIP + "/../" + nextContainer.attributes["href"]!});
          }


        }

      }
      print(charts);
    }

    ADName = document.querySelector('[class="TitleAD"]')?.innerHtml.replaceAll(airfield + '''&nbsp;—&nbsp;
        ''', '').trim();

    ADName += " AIRPORT";
  }

  return [ADName, charts];
}
