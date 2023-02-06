import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:magator/screens/popups/edit_subsection.dart';
import '../../../db/config.dart';
import '../../../db/models.dart' as models;
import '../../../broker/broker.dart';
import '../../../utils/themes/colors.dart';
import '../../popups/delete_subsection.dart';
import '../../popups/utility.dart';
import '../tasks/tasks.dart';

class SectionCard extends StatefulWidget {
  final double? width;
  final double? height;
  final String? cardName;
  final int index;
  const SectionCard(
    {
      this.width, 
      this.height,
      required this.cardName,
      required this.index,
      super.key
    }
  );

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool isActionVisible = false;
  late Broker broker;
  late DataBase db;
  models.Card card = models.Card();

  int getTotalTaskCount() {
    String? savedTasks = db.get("todos", "${card.title}_tasks");
    if (savedTasks != null) {
      models.Tasks tasks = models.Tasks();
      tasks.toObject(savedTasks);
      return tasks.tasks.length;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    String? savedCard = db.get("todos", "${widget.cardName}_c");
    if (savedCard != null) {
      card.toObject(savedCard);
    }

    broker = getBroker();
    broker.register(card.title!);
    broker.listen(card.title!, (event) {
      Protocol protocol = (event as Protocol);
      if (protocol.publisher == "editService") {
        setState(() {
          card = (protocol.data as models.Card);
          isActionVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Badge(
            alignment: AlignmentDirectional(
              widget.width!-22,
              5
            ),
            label: Text("${getTotalTaskCount()}"),
            backgroundColor: Colors.green,
            isLabelVisible: true,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: cardColors[card.colorIndex],
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        card.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    CardDetailDisplay(name: "Preority", value: preorityDict[card.priority]!),
                    CardDetailDisplay(name: "Status", value: card.status!),
                    CardDetailDisplay(name: "Started", value: formateDate(card.startingDate!)),
                    CardDetailDisplay(name: "Deadline", value: formateDate(card.deadline!))
                  ]
                ),
              ),
              
            ),
          ),
          onTap: () {
            if (isActionVisible) {
              setState(() {
                isActionVisible = false;
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyTasks(
                    title: card.title!,
                    colorIndex: card.colorIndex!,
                  )
                )
              );
            }
          },
          onLongPress: () {
            setState(() {
              if (!isActionVisible) {
                isActionVisible = true;
              }
            });
          }
        ),
        Visibility(
          visible: isActionVisible,
          child: Positioned(
            child: Material(
              elevation: 5,
              shadowColor: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) => EditSubSection(card: card)
                          );
                        }, 
                        icon: const Icon(Icons.edit, color: Colors.black)
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) => DeleteEntity(
                              parent: card.parent!,
                              name: card.title!,
                              type: "Card",
                              index: widget.index,
                            )
                          );
                        }, 
                      ),
                    ),
                  ]
                )
              ),
            )
          )
        )
      ],
    );
  }
}

class CardDetailDisplay extends StatelessWidget {
  final String name;
  final String value;
  const CardDetailDisplay({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(color: Colors.black)
        ),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50)
                  ),
                ),
                child: Text(name),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  )
                )
              ),
            )
          ]
        )
      ),
    );
  }
}