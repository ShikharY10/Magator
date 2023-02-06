import 'package:flutter/material.dart';
import '../../broker/broker.dart';

class DeleteEntity extends StatelessWidget {
  final String name;
  final String parent;
  final String type;
  final int index;
  const DeleteEntity({super.key, required this.name, required this.parent, required this.type, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      backgroundColor: const Color.fromARGB(255, 57, 56, 56),
      icon: const Icon(Icons.delete),
      title: Text("Deleting $type: $name"),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/2-69,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 212, 150),
                  borderRadius: BorderRadius.circular(50)
                ),
                child: const Text("Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/2-69,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: const Text("Delete",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ),
            onTap: () {
              Broker broker = getBroker();
              broker.publish("delete",parent, index);
              Navigator.pop(context);
            }
          )
        ]
      ),
    );
  }
}