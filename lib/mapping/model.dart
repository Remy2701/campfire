import 'dart:math';

import 'package:dmp3s/mapping/skill.dart';
import 'package:dmp3s/mapping/_single.dart';
import 'package:dmp3s/mapping/_dual.dart';

/// Execute the mapping model with the given input.
/// Returns a map of all the skills and their respective weights.
///
/// ## Model Process
/// 1. Split into words
/// 2. Foreach word
///    1. Lower case the word
///    2. Check if it's a dual skill (with the previous word)
///    3*. Check if it's a single skill
///
/// * Might be skipped depending on the output of the previous stages.
Map<Skill, int> run(String input) {
  final Map<Skill, int> result = {
    for (final skill in Skill.values) skill: 0,
  };

  final List<String> words = input.split(RegExp(r'[ \n\t,;:.!?"()]'));

  String? previous;
  for (final word_ in words) {
    final word = word_.toLowerCase();
    if (previous != null) {
      final dualRes = dualSkillMap[previous];
      if (dualRes != null) {
        final outcomes = dualRes[word];
        if (outcomes != null) {
          for (final outcome in outcomes) {
            result.update(outcome.skill, (e) => e + outcome.weight);
          }
          previous = null;
          continue;
        }
      }

      final outcomes = skillMap[previous];
      if (outcomes != null) {
        for (final outcome in outcomes) {
          result.update(outcome.skill, (e) => e + outcome.weight);
        }
      }
    }

    previous = word;
  }

  if (previous != null) {
    final outcomes = skillMap[previous];
    if (outcomes != null) {
      for (final outcome in outcomes) {
        result.update(outcome.skill, (e) => e + outcome.weight);
      }
    }
  }

  return result;
}

int computeMatchmakingScore(Map<Skill, int> a, Map<Skill, int> b) {
  int score = 0;
  for (final skill in Skill.values) {
    score += min(a[skill] ?? 0, b[skill] ?? 0);
  }
  return score;
}
