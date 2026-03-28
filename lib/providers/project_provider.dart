import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipyard_planking_tally/models/tool_model.dart';
import 'package:shipyard_planking_tally/providers/image_provider.dart';
import 'package:shipyard_planking_tally/providers/input_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProjectNotifier extends ChangeNotifier {
  ProjectNotifier() {
    loadEntries();
  }

  List<ShipwrightToolModel> entries = [];
  bool isLoading = true;
  static const String _storageKey = 'spt_entries_v1';
  final _uuid = const Uuid();

  Future<void> loadEntries() async {
    isLoading = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        entries = decodedList
            .map((item) => ShipwrightToolModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading entries: $e');
      entries = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      entries.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedList);
  }

  void addEntry(WidgetRef ref) {
    final p = ref.read(inputProvider);
    final imgProv = ref.read(imageProvider);

    entries.add(
      ShipwrightToolModel(
        id: _uuid.v4(),
        shipyardIdentifier: p.shipyardIdentifier,
        toolName: p.toolName,
        toolType: p.toolType,
        specificFunction: p.specificFunction,
        forgeOrMaker: p.forgeOrMaker,
        shipbuildingTradition: p.shipbuildingTradition,
        eraOfProduction: p.eraOfProduction,
        materials: p.materials,
        dimensions: p.dimensions,
        conditionState: p.conditionState,
        markingsAndStamps: p.markingsAndStamps,
        specialFeatures: p.specialFeatures,
        provenance: p.provenance,
        notes: p.notes,
        photoPath: imgProv.resultImage.isNotEmpty
            ? imgProv.resultImage
            : p.photoPath,
        tags: List<String>.from(p.tags),
        dateAdded: p.dateAdded,
      ),
    );

    _save();
    notifyListeners();
  }

  void editEntry(WidgetRef ref, int index) {
    final p = ref.read(inputProvider);
    final imgProv = ref.read(imageProvider);
    final existing = entries[index];

    entries[index] = ShipwrightToolModel(
      id: existing.id,
      shipyardIdentifier: p.shipyardIdentifier,
      toolName: p.toolName,
      toolType: p.toolType,
      specificFunction: p.specificFunction,
      forgeOrMaker: p.forgeOrMaker,
      shipbuildingTradition: p.shipbuildingTradition,
      eraOfProduction: p.eraOfProduction,
      materials: p.materials,
      dimensions: p.dimensions,
      conditionState: p.conditionState,
      markingsAndStamps: p.markingsAndStamps,
      specialFeatures: p.specialFeatures,
      provenance: p.provenance,
      notes: p.notes,
      photoPath: imgProv.resultImage.isNotEmpty
          ? imgProv.resultImage
          : existing.photoPath,
      tags: List<String>.from(p.tags),
      dateAdded: existing.dateAdded,
    );

    _save();
    notifyListeners();
  }

  void deleteEntry(int index) {
    entries.removeAt(index);
    _save();
    notifyListeners();
  }

  void fillInput(WidgetRef ref, int index) {
    final p = ref.read(inputProvider);
    final imgProv = ref.read(imageProvider);
    final entry = entries[index];

    p.shipyardIdentifier = entry.shipyardIdentifier;
    p.toolName = entry.toolName;
    p.toolType = entry.toolType;
    p.specificFunction = entry.specificFunction;
    p.forgeOrMaker = entry.forgeOrMaker;
    p.shipbuildingTradition = entry.shipbuildingTradition;
    p.eraOfProduction = entry.eraOfProduction;
    p.materials = entry.materials;
    p.dimensions = entry.dimensions;
    p.conditionState = entry.conditionState;
    p.markingsAndStamps = entry.markingsAndStamps;
    p.specialFeatures = entry.specialFeatures;
    p.provenance = entry.provenance;
    p.notes = entry.notes;
    p.photoPath = entry.photoPath;
    p.tags = List<String>.from(entry.tags);
    p.dateAdded = entry.dateAdded;

    imgProv.resultImage = entry.photoPath;

    notifyListeners();
  }
}

final projectProvider = ChangeNotifierProvider<ProjectNotifier>(
  (ref) => ProjectNotifier(),
);
