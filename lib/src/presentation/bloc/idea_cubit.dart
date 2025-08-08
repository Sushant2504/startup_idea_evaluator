import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:startup_idea_evaluator/src/domain/entities/idea.dart';
import 'package:startup_idea_evaluator/src/domain/repositories/idea_repository.dart';

enum SortMode { rating, votes }

class IdeaState {
  final List<IdeaEntity> ideas;
  final SortMode sort;
  final bool loading;

  const IdeaState({this.ideas = const [], this.sort = SortMode.rating, this.loading = false});

  IdeaState copyWith({List<IdeaEntity>? ideas, SortMode? sort, bool? loading}) =>
      IdeaState(ideas: ideas ?? this.ideas, sort: sort ?? this.sort, loading: loading ?? this.loading);
}

class IdeaCubit extends Cubit<IdeaState> {
  final _repo = GetIt.I<IdeaRepository>();
  IdeaCubit() : super(const IdeaState());

  Future<void> loadIdeas() async {
    emit(state.copyWith(loading: true));
    final list = await _repo.getIdeas();
    emit(state.copyWith(ideas: _sorted(list, state.sort), loading: false));
  }

  Future<void> submitIdea({required String name, required String tagline, required String description}) async {
    final rating = Random().nextInt(101); // 0..100
    final idea = IdeaEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      tagline: tagline,
      description: description,
      rating: rating,
      votes: 0,
    );
    await _repo.addIdea(idea);
    await loadIdeas();
  }

  Future<void> upvote(String id) async {
    await _repo.upvote(id);
    await loadIdeas();
  }

  void changeSort(SortMode mode) {
    emit(state.copyWith(ideas: _sorted(state.ideas, mode), sort: mode));
  }

  static List<IdeaEntity> _sorted(List<IdeaEntity> list, SortMode mode) {
    final copy = [...list];
    copy.sort((a, b) => mode == SortMode.rating ? b.rating.compareTo(a.rating) : b.votes.compareTo(a.votes));
    return copy;
  }
}


