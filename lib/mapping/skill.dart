enum Skill {
  // Business-Related
  marketing,
  projectManagement,
  strategicManagement,
  finance,
  humanResources,
  operationsManagement,
  buisnessResearch,

  // Engineering
  softwareEngineering,
  hardwareEngineering,
  electricalEngineering,
  electronicsEngineering,
  mechanicalEngineering,
  civilEngineering,
  aerospaceEngineering,
  chemicalEngineering,
  biomedicalEngineering,
  environmentalEngineering,

  // Health Science
  biomedicalResearch,
  clinicalPractice,
  publicHealth,
  pharmacology,
  animalCare,

  // Arts
  graphicDesign,
  webDesign,
  videoEditing,
  photography,
  writing,
  musicProduction,
  acting,
  dancing,

  // Teaching
  teaching,
  publicSpeaking,
  biology,
  history,
  chemistry,
  physics,
  mathematics,
  psychology,
  sociology,
  philosophy,
  politicalScience,
  law,
  economics,

  // Software related
  artificialIntelligence,
  cybersecurity,
  webDevelopment,
  dataAnalysis,
  databaseManagement,
  networkManagement,
}

class WeightedSkill {
  final Skill skill;
  final int weight;

  const WeightedSkill(this.skill, this.weight);
}

class KeywordCombination {
  final String first;
  final String last;

  const KeywordCombination(this.first, this.last);
}
