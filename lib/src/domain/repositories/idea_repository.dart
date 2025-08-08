import 'package:startup_idea_evaluator/src/domain/entities/idea.dart';

abstract class IdeaRepository {
  Future<List<IdeaEntity>> getIdeas();
  Future<void> addIdea(IdeaEntity idea);
  Future<void> upvote(String id);
}


