import 'package:flutter/material.dart';
import '../../utils/themes/colors.dart';

final Map<int, String> preorityDict = {
  1: "Highest",
  2: "High",
  3: "Midium",
  4: "Low",
  5: "Lowest"
};

final Map<int, String> statusDict = {
  1: "In Progress",
  2: "Blocked",
  3: "Finished",
  4: "Pending Action",
  5: "Not Yet Started",
  6: "Closed",
}; 

String formateDate(DateTime date) {
  String initial = date.toString().split(" ")[0];
  List<String> splited = initial.split("-");
  String newDate = splited[2] + "/" + splited[1] + "/" + splited[0];
  return newDate;
}

Map<int, Widget> colorsDropDown() {
    Map<int, Widget> map = {};
    List<int> keys = cardColors.keys.toList();
    List<Color> values = cardColors.values.toList();
    for (int i = 0; i < keys.length; i++) {
      map[keys[i]] = Container(
        width: 100,
        height: 20,
        
        decoration: BoxDecoration(
          color: values[i],
          borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
      );
    }
    return map;
  }

  Map<int, Widget> preorityDropDown() {
    Map<int, Widget> map = {};
    List<int> keys = preorityDict.keys.toList();
    List<String> value = preorityDict.values.toList();

    for (int i = 0; i < keys.length; i++) {
      map[keys[i]] = Container(
        alignment: Alignment.centerLeft,
        child: Text(value[i],
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 28, 29, 77),
            fontWeight: FontWeight.w500,
          )
        )
      );
    }
    return map;
  }

  Map<String, Widget> sectionDropDown(dynamic data) {
    Map<String, Widget> map = {};
    for (int i=0; i<data.length; i++) {
      map[data[i]] = Container(
        alignment: Alignment.center,
        child: Text(data[i])
      );
    }
    return map;
  }

  Map<int, Widget> statusDropDown() {
    Map<int, Widget> map = {};
    List<int> keys = statusDict.keys.toList();
    List<String> values = statusDict.values.toList();
    for (int i=0; i<keys.length; i++) {
      map[keys[i]] = Text(values[i],
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 28, 29, 77),
          fontWeight: FontWeight.w500,
        )
      );
    }
    return map;
  }