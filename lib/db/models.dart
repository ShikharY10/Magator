import 'dart:convert';

class Section {
  final List<String> sections = [];

  @override
  String toString() {
    String jsonEncode = json.encode(sections);
    return jsonEncode;
  }

  toObject(String jsonEncoded) {
    List<dynamic> sectionNames = json.decode(jsonEncoded);
    sectionNames.forEach((value) {
      sections.add(value);
    });
  }
}

class SubSections {
  final List<String> subSections = [];

  @override
  String toString() {
    String jsonEncoded = json.encode(subSections);
    return jsonEncoded;
  }

  toObject(String jsonEncoded) {
    List<dynamic> subSectionNames = json.decode(jsonEncoded);
    for (var value in subSectionNames) {
      subSections.add(value);
    }
  }
}

class Card {
  String? title;
  String? description;
  String? parent;
  int? priority;
  int? colorIndex;
  String? status;
  DateTime? startingDate;
  DateTime? deadline;

  Card({
    this.title, 
    this.description, 
    this.parent,
    this.priority, 
    this.colorIndex, 
    this.status,
    this.startingDate,
    this.deadline,
  });

  @override
  String toString() {
    Map<String ,dynamic> mapForm = {};
    mapForm["title"] = title;
    mapForm["description"] = description;
    mapForm["parent"] = parent;
    mapForm["priority"] = priority;
    mapForm["colorIndex"] = colorIndex;
    mapForm["status"] = status;
    mapForm["startingDate"] = startingDate!.toIso8601String();
    mapForm["deadline"] = deadline!.toIso8601String();
    String jsonEncoded = json.encode(mapForm);
    return jsonEncoded;
  }

  toObject(String data) {
    Map<String, dynamic> mapForm = json.decode(data);
    title = mapForm["title"];
    description = mapForm["description"];
    parent = mapForm["parent"];
    priority = mapForm["priority"];
    colorIndex = mapForm["colorIndex"];
    status = mapForm["status"];
    startingDate = DateTime.parse(mapForm["startingDate"]);
    deadline = DateTime.parse(mapForm["deadline"]);
  }
}

class Tasks {
  final List<String> tasks = [];

  @override
  String toString() {
    String jsonEncoded = json.encode(tasks);
    return jsonEncoded;
  }

  toObject(String jsonEncoded) {
    List<dynamic> newTasks = json.decode(jsonEncoded);
    for (var task in newTasks) {
      tasks.add(task);
    }
  }
}

class Task {
  String? title;
  String? description;
  int? priority;
  int? status;
  String? assigned;
  DateTime? startDate;
  DateTime? deadline;

  Task({
    this.title,
    this.description,
    this.priority,
    this.status,
    this.assigned,
    this.startDate,
    this.deadline
  });

  @override
  String toString() {
    Map<String ,dynamic> mapForm = {};
    mapForm["title"] = title;
    mapForm["description"] = description;
    mapForm["priority"] = priority;
    mapForm["status"] = status;
    mapForm["assigned"] = assigned;
    mapForm["startDate"] = startDate!.toIso8601String();
    mapForm["deadline"] = deadline!.toIso8601String();
    return json.encode(mapForm);
  }

  void toObject(String jsonEncoded) {
    Map<String, dynamic> mapForm = json.decode(jsonEncoded);
    title = mapForm["title"];
    description = mapForm["description"];
    priority = mapForm["priority"];
    status = mapForm["status"];
    assigned = mapForm["assigned"];
    startDate = DateTime.parse(mapForm["startDate"]);
    deadline = DateTime.parse(mapForm["deadline"]);
  }
}