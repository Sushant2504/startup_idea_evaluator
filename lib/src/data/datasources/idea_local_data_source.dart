import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_idea_evaluator/src/domain/entities/idea.dart';

class IdeaLocalDataSource {
  static const _ideasKey = 'ideas_v1';
  static const _votesKey = 'votes_v1'; // stores set of ideaIds voted
  final SharedPreferences prefs;

  IdeaLocalDataSource({required this.prefs});

  Future<List<IdeaEntity>> getIdeas() async {
    final jsonStr = prefs.getString(_ideasKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final list = (json.decode(jsonStr) as List<dynamic>).cast<Map<String, dynamic>>();
    return list
        .map((e) => IdeaEntity(
              id: e['id'] as String,
              name: e['name'] as String,
              tagline: e['tagline'] as String,
              description: e['description'] as String,
              rating: e['rating'] as int,
              votes: e['votes'] as int,
            ))
        .toList();
  }

  Future<void> saveIdeas(List<IdeaEntity> ideas) async {
    final list = ideas
        .map((e) => {
              'id': e.id,
              'name': e.name,
              'tagline': e.tagline,
              'description': e.description,
              'rating': e.rating,
              'votes': e.votes,
            })
        .toList();
    await prefs.setString(_ideasKey, json.encode(list));
  }

  Set<String> getVotedIds() {
    return prefs.getStringList(_votesKey)?.toSet() ?? <String>{};
  }

  Future<void> markVoted(String id) async {
    final set = getVotedIds()..add(id);
    await prefs.setStringList(_votesKey, set.toList());
  }
}


