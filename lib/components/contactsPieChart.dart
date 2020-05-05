import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/myThemes.dart';
import 'package:mycontacts_free/utils/utils.dart';

import '../contact.dart';

class ContactsPieChart extends StatefulWidget {
  // final List<charts.Series> seriesList;
  final bool animate;
  final BuildContext context;
  List<ContactCategory> data = <ContactCategory>[];
  ContactsPieChart(this.context, {this.animate});

  @override
  _ContactsPieChartState createState() => _ContactsPieChartState();
}

class _ContactsPieChartState extends State<ContactsPieChart> {
  List<Contact> contactList;
  List<ContactCategory> data;

  @override
  void initState() {
    super.initState();
    contactList = contactService.current;
    _setPieChartData();
  }

  _getCategoryContactsQuantity(String category) {
    int counter = 0;
    contactList.forEach((contact) {
      if (contact.category == category) {
        counter++;
      }
    });
    return counter;
  }

  _setPieChartData() {
    int generalQuantity = _getCategoryContactsQuantity(
        translatedText("group_default", widget.context));
    int familyQuantity = _getCategoryContactsQuantity(
        translatedText("group_family", widget.context));
    int friendQuantity = _getCategoryContactsQuantity(
        translatedText("group_friend", widget.context));
    int coworkerQuantity = _getCategoryContactsQuantity(
        translatedText("group_coworker", widget.context));

    var labelDefault = translatedText("group_default", widget.context);
    var labelFamily = translatedText("group_family", widget.context);
    var labelFriend = translatedText("group_friend", widget.context);
    var labelCoworker = translatedText("group_coworker", widget.context);

    data = [
      new ContactCategory(labelDefault, 0, generalQuantity),
      new ContactCategory(labelFamily, 1, familyQuantity),
      new ContactCategory(labelFriend, 2, friendQuantity),
      new ContactCategory(labelCoworker, 3, coworkerQuantity),
    ];
  }

  List<charts.Series<ContactCategory, int>> _createSampleData(
      BuildContext context) {
    var graphColor;
    var themeColor = AppSettings.of(context).color.value;
    switch (themeColor) {
      case 4293467747:
        {
          graphColor = charts.MaterialPalette.pink.makeShades(4);
          break;
        }
      case 4294198070:
        {
          graphColor = charts.MaterialPalette.red.makeShades(4);
          break;
        }

      case 4284955319:
        {
          graphColor = charts.MaterialPalette.purple.makeShades(4);
          break;
        }
      case 4288423856:
        {
          graphColor = charts.MaterialPalette.purple.makeShades(4);
          break;
        }
      case 4282339765:
        {
          graphColor = charts.MaterialPalette.indigo.makeShades(4);
          break;
        }
      case 4280391411:
        {
          graphColor = charts.MaterialPalette.blue.makeShades(4);
          break;
        }

      case 4278430196:
        {
          graphColor = charts.MaterialPalette.blue.makeShades(4);
          break;
        }
      case 4278238420:
        {
          graphColor = charts.MaterialPalette.cyan.makeShades(4);
          break;
        }

      case 4278228616:
        {
          graphColor = charts.MaterialPalette.teal.makeShades(4);
          break;
        }
      case 4283215696:
        {
          graphColor = charts.MaterialPalette.green.makeShades(4);
          break;
        }
      case 4287349578:
        {
          graphColor = charts.MaterialPalette.green.makeShades(4);
          break;
        }
      case 4291681337:
        {
          graphColor = charts.MaterialPalette.lime.makeShades(4);
          break;
        }
      case 4294961979:
        {
          graphColor = charts.MaterialPalette.yellow.makeShades(4);
          break;
        }
      case 4294951175:
        {
          graphColor = charts.MaterialPalette.gray.makeShades(4);
          break;
        }
      case 4294924066:
        {
          graphColor = charts.MaterialPalette.deepOrange.makeShades(4);
          break;
        }
      case 4294940672:
        {
          graphColor = charts.MaterialPalette.gray.makeShades(4);
          break;
        }
      case 4288585374:
        {
          graphColor = charts.MaterialPalette.gray.makeShades(4);
          break;
        }
      case 4286141768:
        {
          graphColor = charts.MaterialPalette.gray.makeShades(4);
          break;
        }
      case 4284513675:
        {
          graphColor = charts.MaterialPalette.gray.makeShades(4);
          break;
        }

      default:
        break;
    }

    return [
      charts.Series<ContactCategory, int>(
        id: 'categories',
        domainFn: (ContactCategory sales, _) => sales.order,
        measureFn: (ContactCategory sales, _) => sales.amount,
        data: data,
        labelAccessorFn: (ContactCategory row, _) =>
            '${row.name}: ${row.amount}',
        // colorFn: (_, __) => charts.MaterialPalette.gray.shade400,
        // fillColorFn: (_, __) => charts.MaterialPalette.gray.shade400,
        colorFn: (_, index) => graphColor[index],
        fillColorFn: (_, index) => graphColor[index],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      _createSampleData(context),
      animate: widget.animate,
      animationDuration: Duration(seconds: 3),
      defaultRenderer:
          new charts.ArcRendererConfig(arcWidth: 120, arcRendererDecorators: [
        charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
      ]),
    );
  }
}

class ContactCategory {
  final String name;
  final int order;
  final int amount;

  ContactCategory(this.name, this.order, this.amount);
}
