
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {

  // This is a box according to hive and it will primarily
  // be used specially for storing app settings.
  late Box<String> _settings;

  // This is a box accoring to hive and it will be used
  // specially for storing todos.
  late Box<String> _todos;

  // This function should be called before calling any 
  // other methods of this class. The recommendation is 
  // that this method should be called in entry-point "main()"
  // function. This mwthod initializes Hive database and also
  // opens the hive boxes.
  initilizeHive(String path) async {
    await Hive.initFlutter(path);

    _settings = await Hive.openBox<String>("settings");
    _todos = await Hive.openBox("todos");
  }

  // Used for storing single key/value pair in the database.
  String? get(String boxName, String key) {
    switch (boxName) {
      case "settings":
        return _settings.get(key);
      case "todos":
        return _todos.get(key);
      default:
        return null;
    }
  }

  // Used for getting single key/value pair from the database.
  Future<void> set(String boxName, String key, String value) async {
    switch (boxName) {
      case "settings":
        await _settings.put(key, value);
        break;
      case "todos":
        await _todos.put(key, value);
        break;
      default:
        break;
    }
  }

  Map<String, String> _getAll(Box<String> box) {
    Map<String, String> data = {};
    List<String> values = box.values.toList();
    List<dynamic> keys = box.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      data[keys[i]] = values[i];
    }
    return data;
  }

  // Used for getting multiple key/value pairs at once.
  Map<String, String> getALL(String boxName) {
    switch (boxName) {
      case "settings":
        return _getAll(_settings);
      case "todos":
        return _getAll(_todos);
      default:
        return {};
    }
  }

  Future<void> _setAll(Box<String> box, Map<String, String> entries) async {
    await box.putAll(entries);
  }

  // Used for storing multiple key/values pairs at once.
  Future<void> setAll(String boxName, Map<String, String> pairs) async {
    switch (boxName) {
      case "settings":
        await _setAll(_settings, pairs);
        break;
      case "todos":
        await _setAll(_todos, pairs);
        break;
      default:
        break;
    }
  }

  void showAll(String boxName) {
    switch (boxName) {
      case "settings":
        print(_settings.toMap());
        break;
      case "todos":
        print(_todos.toMap());
        break;
      default:
    }
  }

  void clearBox(boxName) {
    switch (boxName) {
      case "settings":
        _settings.clear();
        break;
      case "todos":
        _todos.clear();
        break;
      default:
    }
  }

  void delete(String boxName, String key) {
    switch (boxName) {
      case "settings":
        _settings.delete(key);
        break;
      case "todos":
        _todos.delete(key);
        break;
      default:
    }
  }
}