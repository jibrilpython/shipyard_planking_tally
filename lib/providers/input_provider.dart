import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shipyard_planking_tally/enum/my_enums.dart';

class InputNotifier extends ChangeNotifier {
  String _shipyardIdentifier = '';
  String _toolName = '';
  ToolType _toolType = ToolType.holdfast;
  String _specificFunction = '';
  String _forgeOrMaker = '';
  ShipbuildingTradition _shipbuildingTradition = ShipbuildingTradition.unknown;
  String _eraOfProduction = '';
  String _materials = '';
  String _dimensions = '';
  ConditionState _conditionState = ConditionState.unknown;
  String _markingsAndStamps = '';
  String _specialFeatures = '';
  String _provenance = '';
  String _notes = '';
  String _photoPath = '';
  List<String> _tags = [];
  DateTime _dateAdded = DateTime.now();

  // Getters
  String get shipyardIdentifier => _shipyardIdentifier;
  String get toolName => _toolName;
  ToolType get toolType => _toolType;
  String get specificFunction => _specificFunction;
  String get forgeOrMaker => _forgeOrMaker;
  ShipbuildingTradition get shipbuildingTradition => _shipbuildingTradition;
  String get eraOfProduction => _eraOfProduction;
  String get materials => _materials;
  String get dimensions => _dimensions;
  ConditionState get conditionState => _conditionState;
  String get markingsAndStamps => _markingsAndStamps;
  String get specialFeatures => _specialFeatures;
  String get provenance => _provenance;
  String get notes => _notes;
  String get photoPath => _photoPath;
  List<String> get tags => _tags;
  DateTime get dateAdded => _dateAdded;

  // Setters
  set shipyardIdentifier(String v) { _shipyardIdentifier = v; notifyListeners(); }
  set toolName(String v) { _toolName = v; notifyListeners(); }
  set toolType(ToolType v) { _toolType = v; notifyListeners(); }
  set specificFunction(String v) { _specificFunction = v; notifyListeners(); }
  set forgeOrMaker(String v) { _forgeOrMaker = v; notifyListeners(); }
  set shipbuildingTradition(ShipbuildingTradition v) { _shipbuildingTradition = v; notifyListeners(); }
  set eraOfProduction(String v) { _eraOfProduction = v; notifyListeners(); }
  set materials(String v) { _materials = v; notifyListeners(); }
  set dimensions(String v) { _dimensions = v; notifyListeners(); }
  set conditionState(ConditionState v) { _conditionState = v; notifyListeners(); }
  set markingsAndStamps(String v) { _markingsAndStamps = v; notifyListeners(); }
  set specialFeatures(String v) { _specialFeatures = v; notifyListeners(); }
  set provenance(String v) { _provenance = v; notifyListeners(); }
  set notes(String v) { _notes = v; notifyListeners(); }
  set photoPath(String v) { _photoPath = v; notifyListeners(); }
  set tags(List<String> v) { _tags = v; notifyListeners(); }
  set dateAdded(DateTime v) { _dateAdded = v; notifyListeners(); }

  void clearAll() {
    _shipyardIdentifier = '';
    _toolName = '';
    _toolType = ToolType.holdfast;
    _specificFunction = '';
    _forgeOrMaker = '';
    _shipbuildingTradition = ShipbuildingTradition.unknown;
    _eraOfProduction = '';
    _materials = '';
    _dimensions = '';
    _conditionState = ConditionState.unknown;
    _markingsAndStamps = '';
    _specialFeatures = '';
    _provenance = '';
    _notes = '';
    _photoPath = '';
    _tags = [];
    _dateAdded = DateTime.now();
    notifyListeners();
  }
}

final inputProvider = ChangeNotifierProvider<InputNotifier>(
  (ref) => InputNotifier(),
);
