import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:magator/screens/popups/add_section.dart';
import 'package:magator/screens/sections/section.dart';
import 'package:magator/utils/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db/config.dart';
import '../db/models.dart' as models;
import '../broker/broker.dart';
import 'popups/add_subsection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DataBase db;
  late Broker broker;
  late models.Section section;

  @override
  void initState() {
    super.initState();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    broker = getBroker();

    section = models.Section();
    String? sections = db.get("todos", "sections");
    if (sections != null) {
      section.toObject(sections);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const Padding(
          padding: EdgeInsets.only(left : 4.0),
          child: Icon(Icons.account_tree),
        ),
        leadingWidth: 30,
        title: const Text("Magator"),
        titleSpacing: 0.0,
        actions: [
          IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.playlist_add_rounded),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return AddNewSection(
                    onSubmit: (sectionName) {
                      section.sections.add(sectionName);
                      String str = section.toString();
                      db.set("todos", "sections", str);
                      setState(() {});
                    }
                  );
                }
              );
            },
          ),
          IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.add_card_rounded),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return AddNewSubSection(
                    sections: section.sections,
                    onSubmit: (data) {
                      models.SubSections subSection = models.SubSections();
                      String? subSectionNames = db.get("todos", "${data["section"]}_cards");

                      if (subSectionNames != null) {
                        subSection.toObject(subSectionNames);
                      }
                      subSection.subSections.add((data["title"] as String));
                      String jsonEncodedSubSection = subSection.toString();

                      models.Card card = models.Card();
                      card.colorIndex = data["color"];
                      card.deadline = data["deadline"];
                      card.description = data["description"];
                      card.parent = data["section"];
                      card.priority = data["priority"];
                      card.startingDate = data["startingDate"];
                      card.status = data["status"];
                      card.title = data["title"];
                      String jsonEncodedCard = card.toString();

                      db.set("todos", "${data["title"]}_c", jsonEncodedCard);
                      db.set("todos", "${data["section"]}_cards", jsonEncodedSubSection);

                      broker.publish("addNewCard", data["section"], card);
                    }
                  );
                }
              );
            },
          ),
          IconButton(
            splashRadius:25,
            icon: const Icon(Icons.feedback),
            onPressed: () async {
              String url = "https://docs.google.com/forms/d/e/1FAIpQLSfm8UfJNKQ7-2fRD43evrfHiXOta6rsUJ0g0aHF-nLltcI_4Q/viewform?usp=sf_link";
              bool isLaunchable = await canLaunchUrl(Uri.parse(url));
              if (isLaunchable) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication
                );
              } else {
                print("Not Working!");
              }
              
              
            }
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            for (int i = 0; i < section.sections.length; i++)
              Section(section.sections[i])
          ]
        )
      ),
    );
  }
}