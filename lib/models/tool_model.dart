import 'package:shipyard_planking_tally/enum/my_enums.dart';

class ShipwrightToolModel {
  String id;
  String shipyardIdentifier;
  String toolName;
  ToolType toolType;
  String specificFunction;
  String forgeOrMaker;
  ShipbuildingTradition shipbuildingTradition;
  String eraOfProduction;
  String materials;
  String dimensions;
  ConditionState conditionState;
  String markingsAndStamps;
  String specialFeatures;
  String provenance;
  String notes;
  String photoPath;
  List<String> tags;
  DateTime dateAdded;

  ShipwrightToolModel({
    required this.id,
    required this.shipyardIdentifier,
    required this.toolName,
    required this.toolType,
    required this.specificFunction,
    required this.forgeOrMaker,
    required this.shipbuildingTradition,
    required this.eraOfProduction,
    required this.materials,
    required this.dimensions,
    required this.conditionState,
    required this.markingsAndStamps,
    required this.specialFeatures,
    required this.provenance,
    required this.notes,
    required this.photoPath,
    required this.tags,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'shipyardIdentifier': shipyardIdentifier,
        'toolName': toolName,
        'toolType': toolType.name,
        'specificFunction': specificFunction,
        'forgeOrMaker': forgeOrMaker,
        'shipbuildingTradition': shipbuildingTradition.name,
        'eraOfProduction': eraOfProduction,
        'materials': materials,
        'dimensions': dimensions,
        'conditionState': conditionState.name,
        'markingsAndStamps': markingsAndStamps,
        'specialFeatures': specialFeatures,
        'provenance': provenance,
        'notes': notes,
        'photoPath': photoPath,
        'tags': tags,
        'dateAdded': dateAdded.toIso8601String(),
      };

  factory ShipwrightToolModel.fromJson(Map<String, dynamic> json) =>
      ShipwrightToolModel(
        id: json['id'] ?? '',
        shipyardIdentifier: json['shipyardIdentifier'] ?? '',
        toolName: json['toolName'] ?? '',
        toolType: ToolType.values.asNameMap()[json['toolType']] ?? ToolType.other,
        specificFunction: json['specificFunction'] ?? '',
        forgeOrMaker: json['forgeOrMaker'] ?? '',
        shipbuildingTradition: ShipbuildingTradition.values
                .asNameMap()[json['shipbuildingTradition']] ??
            ShipbuildingTradition.unknown,
        eraOfProduction: json['eraOfProduction'] ?? '',
        materials: json['materials'] ?? '',
        dimensions: json['dimensions'] ?? '',
        conditionState: ConditionState.values
                .asNameMap()[json['conditionState']] ??
            ConditionState.unknown,
        markingsAndStamps: json['markingsAndStamps'] ?? '',
        specialFeatures: json['specialFeatures'] ?? '',
        provenance: json['provenance'] ?? '',
        notes: json['notes'] ?? '',
        photoPath: json['photoPath'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        dateAdded: DateTime.tryParse(json['dateAdded'] ?? '') ?? DateTime.now(),
      );
}
