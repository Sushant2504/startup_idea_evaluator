import 'package:equatable/equatable.dart';

class IdeaEntity extends Equatable {
  final String id; // uuid
  final String name;
  final String tagline;
  final String description;
  final int rating; // 0-100
  final int votes; // count

  const IdeaEntity({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.rating,
    required this.votes,
  });

  IdeaEntity copyWith({
    String? id,
    String? name,
    String? tagline,
    String? description,
    int? rating,
    int? votes,
  }) => IdeaEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        tagline: tagline ?? this.tagline,
        description: description ?? this.description,
        rating: rating ?? this.rating,
        votes: votes ?? this.votes,
      );

  @override
  List<Object?> get props => [id, name, tagline, description, rating, votes];
}


