import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum ActivityType { feeding, sleep, diaper }
enum FeedingType { breast, bottle }
enum BreastSide { left, right, both }
enum DiaperType { wet, dirty, both }
enum SleepStatus { sleeping, awake }

class Activity {
  final String id;
  final ActivityType type;
  final DateTime time;
  final Map<String, dynamic> details;

  Activity({
    required this.id,
    required this.type,
    required this.time,
    required this.details,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'time': time.toIso8601String(),
        'details': details,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'],
        type: ActivityType.values[json['type']],
        time: DateTime.parse(json['time']),
        details: json['details'],
      );
}

class BabyProvider extends ChangeNotifier {
  String _babyName = 'Bebek';
  List<Activity> _activities = [];
  final _uuid = const Uuid();

  String get babyName => _babyName;
  List<Activity> get activities => _activities;

  List<Activity> get todayActivities {
    final now = DateTime.now();
    return _activities
        .where((a) =>
            a.time.year == now.year &&
            a.time.month == now.month &&
            a.time.day == now.day)
        .toList()
      ..sort((a, b) => b.time.compareTo(a.time));
  }

  double get todayFeedingMl {
    return todayActivities
        .where((a) => a.type == ActivityType.feeding)
        .fold(0.0, (sum, a) => sum + (a.details['amount_ml'] ?? 0));
  }

  double get todaySleepHours {
    final sleepActivities = todayActivities
        .where((a) => a.type == ActivityType.sleep && a.details['duration_min'] != null)
        .toList();
    final totalMin = sleepActivities.fold(0, (sum, a) => sum + (a.details['duration_min'] as int));
    return totalMin / 60;
  }

  int get todayDiaperCount {
    return todayActivities.where((a) => a.type == ActivityType.diaper).length;
  }

  Activity? get lastFeeding {
    final feedings = _activities.where((a) => a.type == ActivityType.feeding).toList();
    if (feedings.isEmpty) return null;
    feedings.sort((a, b) => b.time.compareTo(a.time));
    return feedings.first;
  }

  DateTime? get nextFeedingTime {
    final last = lastFeeding;
    if (last == null) return null;
    return last.time.add(const Duration(hours: 3));
  }

  BabyProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _babyName = prefs.getString('baby_name') ?? 'Bebek';
    final activitiesJson = prefs.getStringList('activities') ?? [];
    _activities = activitiesJson
        .map((e) => Activity.fromJson(jsonDecode(e)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baby_name', _babyName);
    await prefs.setStringList(
        'activities', _activities.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<void> setBabyName(String name) async {
    _babyName = name;
    await _saveData();
    notifyListeners();
  }

  Future<void> addFeeding({
    required FeedingType feedingType,
    double? amountMl,
    BreastSide? side,
    int? durationMin,
  }) async {
    _activities.add(Activity(
      id: _uuid.v4(),
      type: ActivityType.feeding,
      time: DateTime.now(),
      details: {
        'feeding_type': feedingType.index,
        'amount_ml': amountMl ?? 0,
        'side': side?.index,
        'duration_min': durationMin ?? 0,
      },
    ));
    await _saveData();
    notifyListeners();
  }

  Future<void> addSleep({required int durationMin}) async {
    _activities.add(Activity(
      id: _uuid.v4(),
      type: ActivityType.sleep,
      time: DateTime.now(),
      details: {'duration_min': durationMin},
    ));
    await _saveData();
    notifyListeners();
  }

  Future<void> addDiaper({required DiaperType diaperType}) async {
    _activities.add(Activity(
      id: _uuid.v4(),
      type: ActivityType.diaper,
      time: DateTime.now(),
      details: {'diaper_type': diaperType.index},
    ));
    await _saveData();
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    _activities.removeWhere((a) => a.id == id);
    await _saveData();
    notifyListeners();
  }
}
