import 'dart:async';
import 'package:flutter/material.dart';

/// Practice implementation of a datetime stream reliant changenotifier
/// class that manages **multiple states** of multiple objects 
class TimeReliantStateProvider extends ChangeNotifier {
  late BuildContext _internalContext;

  // the date time object that *is used* to keep track of states
  DateTime _currentTimeObj = DateTime.fromMicrosecondsSinceEpoch(989452800000); // ignore: prefer_final_fields
  DateTime get currentDateTime => _currentTimeObj;

  // example map of objects with multiple states
  // inner map is the supposedly expiry of state
  List<Map<DateTime, (String, int)>> _expiryQueue = []; // ignore: prefer_final_fields
  Map<String, Map<int, (DateTime, DateTime)>> _objectsStateMap = {};
  Map<String, Map<int, (DateTime, DateTime)>> get objectsStateMap => _objectsStateMap;

  void init(BuildContext context) {
    _internalContext = context;
    // initialize object state map
    for (int i in List.generate(5, (i) => i)) {
      Map<int, (DateTime, DateTime)> finalStateMap = {
        100 : (DateTime.now(), DateTime.now().add(const Duration(seconds: 10))),
        200 : (DateTime.now(), DateTime.now().add(const Duration(seconds: 20))),
        300 : (DateTime.now(), DateTime.now().add(const Duration(seconds: 30)))
      };
      _objectsStateMap[i.toString()] = finalStateMap;
      for (int key in finalStateMap.keys) {
        _expiryQueue.add({
          finalStateMap[key]!.$2 : (i.toString(), key)
        });
      }
    }
    _expiryQueue.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    //print(_expiryQueue.toString());
    notifyListeners();
    return;
  }

  // the date time stream listener function
  // manages the state
  void startListener() {
    _dtTicker().listen(
      (dt) {
        //print(_expiryQueue.toString());
        //print(_objectsStateMap.toString());
        try {
          if (dt.compareTo(_expiryQueue[0].keys.first) == 1) {
            _objectsStateMap[_expiryQueue[0][_expiryQueue[0].keys.first]!.$1]!.remove(_expiryQueue[0][_expiryQueue[0].keys.first]!.$2);
            print('removed -> ${_expiryQueue.removeAt(0)}');
            notifyListeners();
          }
        } on RangeError catch (e) {
          null;
        }
      }
    );
  }

  // the date time ticker function
  Stream<DateTime> _dtTicker() async* {
    while (true) {
      yield DateTime.now();
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}