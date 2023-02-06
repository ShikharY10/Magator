import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:magator/screens/sections/cards.dart';
import 'package:magator/screens/sections/section_seperator.dart';
import '../../db/models.dart' as models;
import '../../db/config.dart';
import '../../broker/broker.dart';

class Section extends StatefulWidget {
  final String name;
  const Section(this.name, {super.key});

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  late Broker broker;
  late DataBase db;

  bool isClose = true;
  models.SubSections subSections = models.SubSections();
  List<models.Card> cardList = [];
  int count = 0;

  eventListner() {
    broker.listen(widget.name, (event) {
      Protocol protocol = (event as Protocol);
      if (protocol.publisher == "${widget.name}_seperator") {
        setState(() {
          isClose = (protocol.data as bool);
        });
      } else if (protocol.publisher == "addNewCard") {
        subSections.subSections.add((protocol.data as models.Card).title!);
        // cardList.add(protocol.data);
        setState(() {});
      } else if (protocol.publisher == "delete") {
        // TODO: Implement card delete logic
      } else if (protocol.publisher == "editService") {
        
        setState(() {
          
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    String? subSection = db.get("todos", "${widget.name}_cards");
    if (subSection != null) {
      subSections.toObject(subSection);
    }

    broker = getBroker();
    broker.register(widget.name);
    eventListner();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionSeperator(widget.name),
        Visibility(
          visible: !isClose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                for (int i=0; i < subSections.subSections.length; count=0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        for (; count < 2 && i < subSections.subSections.length; i++, count++)
                          Padding(
                            padding: EdgeInsets.only(right: (i%2==0) ? 5.0 : 0.0, left: (i%2!=0) ? 5.0 : 0.0),
                            child: SectionCard(
                              width: MediaQuery.of(context).size.width/2-20,
                              height: MediaQuery.of(context).size.width/2-30,
                              cardName: subSections.subSections[i]
                            ),
                          )
                      ]
                    )
                  )
              ]
            )
          ),
        ),
      ]
    );
  }
}