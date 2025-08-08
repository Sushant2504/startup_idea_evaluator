import 'package:startup_idea_evaluator/src/data/datasources/idea_local_data_source.dart';
import 'package:startup_idea_evaluator/src/domain/entities/idea.dart';
import 'package:startup_idea_evaluator/src/domain/repositories/idea_repository.dart';

class IdeaRepositoryImpl implements IdeaRepository {
  final IdeaLocalDataSource local;

  IdeaRepositoryImpl({required this.local});

  @override
  Future<void> addIdea(IdeaEntity idea) async {
    final list = await local.getIdeas();
    list.add(idea);
    await local.saveIdeas(list);
  }

  @override
  Future<List<IdeaEntity>> getIdeas() => local.getIdeas();

  @override
  Future<void> upvote(String id) async {
    // prevent multiple votes
    final voted = local.getVotedIds();
    if (voted.contains(id)) return;
    final list = await local.getIdeas();
    final updated = list.map((e) => e.id == id ? e.copyWith(votes: e.votes + 1) : e).toList();
    await local.saveIdeas(updated);
    await local.markVoted(id);
  }
}


