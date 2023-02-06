import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../db/config.dart';
import '../../broker/broker.dart';

class DeleteEntity extends StatelessWidget {
  final String name;
  final String entityKey;
  final String parent;
  final String type;
  const DeleteEntity({super.key, required this.name, required this.entityKey, required this.parent, required this.type});

  @override
  Widget build(BuildContext context) {
    DataBase db = GetIt.I.get<DataBase>(instanceName: "db");
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
              db.delete("todos", entityKey);
              Broker broker = getBroker();
              broker.publish("delete",parent, 1);
            }
          )
        ]
      ),
    );
  }
}