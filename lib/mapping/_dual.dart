import 'package:dmp3s/mapping/skill.dart';

const Map<String, Map<String, List<WeightedSkill>>> dualSkillMap = {
  'computer': {
    'science': [
      WeightedSkill(Skill.softwareEngineering, 10),
    ],
  },
  'software': {
    'engineering': [
      WeightedSkill(Skill.softwareEngineering, 10),
    ],
    'engineer': [
      WeightedSkill(Skill.softwareEngineering, 10),
    ],
    'solution': [
      WeightedSkill(Skill.buisnessResearch, 6),
    ],
    'solutions': [
      WeightedSkill(Skill.buisnessResearch, 6),
    ],
  },
  'web': {
    'development': [
      WeightedSkill(Skill.webDevelopment, 10),
    ],
    'developper': [
      WeightedSkill(Skill.webDevelopment, 10),
    ],
    'application': [
      WeightedSkill(Skill.webDevelopment, 8),
    ],
    'applications': [
      WeightedSkill(Skill.webDevelopment, 8),
    ],
  },
  'user': {
    'interface': [
      WeightedSkill(Skill.webDevelopment, 6),
    ],
    'interfaces': [
      WeightedSkill(Skill.webDevelopment, 6),
    ],
    'experience': [
      WeightedSkill(Skill.webDevelopment, 6),
    ],
    'experiences': [
      WeightedSkill(Skill.webDevelopment, 6),
    ],
    'acquisition': [
      WeightedSkill(Skill.marketing, 10),
    ],
  },
  'artificial': {
    'intelligence': [
      WeightedSkill(Skill.artificialIntelligence, 10),
    ],
  },
  'machine': {
    'learning': [
      WeightedSkill(Skill.artificialIntelligence, 10),
    ],
    'design': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
  },
  'deep': {
    'learning': [
      WeightedSkill(Skill.artificialIntelligence, 10),
    ],
  },
  'natural': {
    'language': [
      WeightedSkill(Skill.artificialIntelligence, 6),
    ],
    'languages': [
      WeightedSkill(Skill.artificialIntelligence, 6),
    ],
  },
  'neural': {
    'networks': [
      WeightedSkill(Skill.artificialIntelligence, 8),
    ],
  },
  'cisco': {
    'systems': [
      WeightedSkill(Skill.networkManagement, 8),
    ],
  },
  'cloud': {
    'computing': [
      WeightedSkill(Skill.networkManagement, 6),
    ],
    'storage': [
      WeightedSkill(Skill.databaseManagement, 6),
    ],
  },
  'network': {
    'security': [
      WeightedSkill(Skill.cybersecurity, 10),
    ],
  },
  'ethical': {
    'hacking': [
      WeightedSkill(Skill.cybersecurity, 10),
    ],
  },
  'big': {
    'data': [
      WeightedSkill(Skill.dataAnalysis, 8),
    ],
  },
  'data': {
    'visualisation': [
      WeightedSkill(Skill.dataAnalysis, 6),
    ],
    'visualisations': [
      WeightedSkill(Skill.dataAnalysis, 6),
    ],
    'visualization': [
      WeightedSkill(Skill.dataAnalysis, 6),
    ],
    'visualizations': [
      WeightedSkill(Skill.dataAnalysis, 6),
    ],
    'analysis': [
      WeightedSkill(Skill.dataAnalysis, 6),
    ],
    'mining': [
      WeightedSkill(Skill.dataAnalysis, 6),
    ],
  },
  'project': {
    'management': [
      WeightedSkill(Skill.projectManagement, 10),
    ],
    'manager': [
      WeightedSkill(Skill.projectManagement, 10),
    ],
  },
  'projects': {
    'management': [
      WeightedSkill(Skill.projectManagement, 10),
    ],
    'manager': [
      WeightedSkill(Skill.projectManagement, 10),
    ],
  },
  'lean': {
    'management': [
      WeightedSkill(Skill.projectManagement, 8),
    ],
  },
  'strategic': {
    'planning': [
      WeightedSkill(Skill.projectManagement, 8),
    ],
  },
  'decision': {
    'making': [
      WeightedSkill(Skill.projectManagement, 5),
    ],
  },
  'digital': {
    'marketing': [
      WeightedSkill(Skill.marketing, 10),
    ],
  },
  'market': {
    'research': [
      WeightedSkill(Skill.marketing, 10),
      WeightedSkill(Skill.buisnessResearch, 6),
    ],
    'analysis': [
      WeightedSkill(Skill.buisnessResearch, 6),
    ],
  },
  'social': {
    'media': [
      WeightedSkill(Skill.marketing, 10),
    ],
    'network': [
      WeightedSkill(Skill.marketing, 6),
    ],
    'networks': [
      WeightedSkill(Skill.marketing, 6),
    ],
  },
  'content': {
    'marketing': [
      WeightedSkill(Skill.marketing, 10),
    ],
  },
  'email': {
    'marketing': [
      WeightedSkill(Skill.marketing, 10),
    ],
  },
  'google': {
    'analytics': [
      WeightedSkill(Skill.marketing, 6),
    ],
  },
  'focus': {
    'group': [
      WeightedSkill(Skill.marketing, 4),
    ],
  },
  'affiliate': {
    'marketing': [
      WeightedSkill(Skill.marketing, 10),
    ],
  },
  'brand': {
    'strategy': [
      WeightedSkill(Skill.marketing, 7),
    ],
    'strategies': [
      WeightedSkill(Skill.marketing, 7),
    ],
    'story': [
      WeightedSkill(Skill.marketing, 6),
    ],
    'stories': [
      WeightedSkill(Skill.marketing, 6),
    ],
  },
  'marketing': {
    'strategy': [
      WeightedSkill(Skill.marketing, 7),
    ],
    'strategies': [
      WeightedSkill(Skill.marketing, 7),
    ],
    'campaign': [
      WeightedSkill(Skill.marketing, 8),
    ],
    'campaigns': [
      WeightedSkill(Skill.marketing, 8),
    ],
  },
  'acquisition': {
    'strategy': [
      WeightedSkill(Skill.marketing, 10),
    ],
    'strategies': [
      WeightedSkill(Skill.marketing, 10),
    ],
  },
  'business': {
    'strategy': [
      WeightedSkill(Skill.strategicManagement, 10),
    ],
    'strategies': [
      WeightedSkill(Skill.strategicManagement, 10),
    ],
    'analysis': [
      WeightedSkill(Skill.buisnessResearch, 8),
    ],
    'research': [
      WeightedSkill(Skill.buisnessResearch, 8),
    ],
  },
  'competitive': {
    'analysis': [
      WeightedSkill(Skill.strategicManagement, 10),
    ],
  },
  'innovation': {
    'management': [
      WeightedSkill(Skill.strategicManagement, 7),
    ],
  },
  'investement': {
    'analysis': [
      WeightedSkill(Skill.finance, 10),
    ],
    'strategy': [
      WeightedSkill(Skill.finance, 10),
    ],
    'strategies': [
      WeightedSkill(Skill.finance, 10),
    ],
  },
  'risk': {
    'management': [
      WeightedSkill(Skill.finance, 2),
    ],
  },
  'financial': {
    'analysis': [
      WeightedSkill(Skill.finance, 10),
    ],
    'market': [
      WeightedSkill(Skill.finance, 10),
    ],
    'markets': [
      WeightedSkill(Skill.finance, 10),
    ],
    'modeling': [
      WeightedSkill(Skill.finance, 8),
    ],
    'consulting': [
      WeightedSkill(Skill.finance, 8),
    ],
  },
  'portfolio': {
    'management': [
      WeightedSkill(Skill.finance, 8),
    ],
  },
  'stock': {
    'market': [
      WeightedSkill(Skill.finance, 8),
    ],
  },
  'human': {
    'resources': [
      WeightedSkill(Skill.humanResources, 10),
    ],
  },
  'recruitment': {
    'strategy': [
      WeightedSkill(Skill.humanResources, 10),
    ],
    'strategies': [
      WeightedSkill(Skill.humanResources, 10),
    ],
  },
  'training': {
    'development': [
      WeightedSkill(Skill.humanResources, 10),
    ],
  },
  'employee': {
    'engagement': [
      WeightedSkill(Skill.humanResources, 10),
    ],
    'relations': [
      WeightedSkill(Skill.humanResources, 10),
    ],
  },
  'labor': {
    'relations': [
      WeightedSkill(Skill.humanResources, 10),
    ],
  },
  'performance': {
    'management': [
      WeightedSkill(Skill.humanResources, 7),
    ],
  },
  'talent': {
    'management': [
      WeightedSkill(Skill.humanResources, 8),
    ],
  },
  'conflict': {
    'resolution': [
      WeightedSkill(Skill.humanResources, 6),
    ],
    'management': [
      WeightedSkill(Skill.humanResources, 6),
    ],
  },
  'networking': {
    'event': [
      WeightedSkill(Skill.humanResources, 6),
    ],
    'events': [
      WeightedSkill(Skill.humanResources, 6),
    ],
  },
  'operation': {
    'management': [
      WeightedSkill(Skill.operationsManagement, 8),
    ],
    'manager': [
      WeightedSkill(Skill.operationsManagement, 8),
    ],
  },
  'operations': {
    'management': [
      WeightedSkill(Skill.operationsManagement, 8),
    ],
    'manager': [
      WeightedSkill(Skill.operationsManagement, 8),
    ],
  },
  'supply': {
    'chain': [
      WeightedSkill(Skill.operationsManagement, 8),
    ],
    'chains': [
      WeightedSkill(Skill.operationsManagement, 8),
    ],
  },
  'quality': {
    'control': [
      WeightedSkill(Skill.operationsManagement, 4),
    ],
  },
  'facility': {
    'management': [
      WeightedSkill(Skill.operationsManagement, 7),
    ],
    'managemer': [
      WeightedSkill(Skill.operationsManagement, 7),
    ],
  },
  'trend': {
    'analysis': [
      WeightedSkill(Skill.buisnessResearch, 8),
    ],
  },
  'competitor': {
    'analysis': [
      WeightedSkill(Skill.buisnessResearch, 6),
    ],
  },
  'a/b': {
    'testing': [
      WeightedSkill(Skill.buisnessResearch, 6),
    ],
  },
  'mechanical': {
    'engineer': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
    'engineering': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
    'system': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
    'systems': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
  },
  'manufacturing': {
    'process': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
  },
  'fusion': {
    '360': [
      WeightedSkill(Skill.mechanicalEngineering, 10),
    ],
  },
  '2d': {
    'design': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'designs': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'model': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'models': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'modeling': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
  },
  '3d': {
    'design': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'designs': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'model': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'models': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'modeling': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'priting': [
      WeightedSkill(Skill.mechanicalEngineering, 8),
    ],
  },
  '2d/3d': {
    'design': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'designs': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'model': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'models': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'modeling': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
  },
  'cad': {
    'software': [
      WeightedSkill(Skill.mechanicalEngineering, 9),
    ],
    'softwares': [
      WeightedSkill(Skill.mechanicalEngineering, 9),
    ],
    'tool': [
      WeightedSkill(Skill.mechanicalEngineering, 9),
    ],
    'tools': [
      WeightedSkill(Skill.mechanicalEngineering, 9),
    ],
  },
  'fluid': {
    'mechanics': [
      WeightedSkill(Skill.mechanicalEngineering, 9),
    ],
  },
  'material': {
    'science': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
  },
  'materials': {
    'science': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
  },
  'automotive': {
    'industry': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
    'industries': [
      WeightedSkill(Skill.mechanicalEngineering, 6),
    ],
  },
  'sustainable': {
    'engineering': [
      WeightedSkill(Skill.mechanicalEngineering, 8),
    ],
  },
  'electronic': {
    'engineering': [
      WeightedSkill(Skill.electronicsEngineering, 10),
    ],
    'engineer': [
      WeightedSkill(Skill.electronicsEngineering, 10),
    ],
  },
  'circuit': {
    'design': [
      WeightedSkill(Skill.electronicsEngineering, 10),
    ],
  },
  'pcb': {
    'layout': [
      WeightedSkill(Skill.electronicsEngineering, 10),
    ],
    'design': [
      WeightedSkill(Skill.electronicsEngineering, 10),
    ],
  },
  'signal': {
    'processing': [
      WeightedSkill(Skill.electronicsEngineering, 10),
      WeightedSkill(Skill.softwareEngineering, 6),
    ],
  },
  'embeedded': {
    'system': [
      WeightedSkill(Skill.electronicsEngineering, 8),
      WeightedSkill(Skill.softwareEngineering, 8),
    ],
    'systems': [
      WeightedSkill(Skill.electronicsEngineering, 8),
      WeightedSkill(Skill.softwareEngineering, 8),
    ],
  },
};
