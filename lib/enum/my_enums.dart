enum ToolType {
  holdfast('Holdfast'),
  plankDog('Plank Dog'),
  spilingClamp('Spiling Clamp'),
  wedgeClamp('Wedge Clamp'),
  ribbandClamp('Ribband Clamp'),
  hollowAuger('Hollow Auger'),
  shipwrightMallet('Shipwright\'s Mallet'),
  treenailDriver('Treenail Driver'),
  other('Other');

  const ToolType(this.label);
  final String label;
}

enum ShipbuildingTradition {
  norwegianFaering('Norwegian Faering'),
  newEnglandSchooner('New England Schooner'),
  englishCutter('English Cutter'),
  balticTrader('Baltic Trader'),
  grandBanksDory('Grand Banks Dory'),
  unknown('Unknown');

  const ShipbuildingTradition(this.label);
  final String label;
}

enum ConditionState {
  workingCondition('Working Condition'),
  displayCondition('Display Condition'),
  forConservation('For Conservation'),
  forParts('For Parts'),
  unknown('Unknown');

  const ConditionState(this.label);
  final String label;
}
