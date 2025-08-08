import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/idea_cubit.dart';
import '../styles/gradients.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: BlocBuilder<IdeaCubit, IdeaState>(
        builder: (context, state) {
          final sortedByVotes = [...state.ideas]..sort((a, b) => b.votes.compareTo(a.votes));
          final top = sortedByVotes.take(5).toList();
          if (top.isEmpty) return const Center(child: Text('No ideas yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: top.length,
            itemBuilder: (_, i) {
              final idea = top[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: AppGradients.hushhSoft,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: ListTile(
                  leading: _Medal(index: i),
                  title: Text(idea.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Votes: ${idea.votes} | Rating: ${idea.rating}/100'),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const _BottomNav(current: 2),
    );
  }
}

class _Medal extends StatelessWidget {
  final int index;
  const _Medal({required this.index});
  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return const Text('🥇', style: TextStyle(fontSize: 24));
      case 1:
        return const Text('🥈', style: TextStyle(fontSize: 24));
      case 2:
        return const Text('🥉', style: TextStyle(fontSize: 24));
      default:
        return CircleAvatar(child: Text('#${index + 1}'));
    }
  }
}

class _BottomNav extends StatelessWidget {
  final int current; // 0 submit, 1 list, 2 leaderboard
  const _BottomNav({required this.current});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: current,
      onDestinationSelected: (i) {
        if (i == current) return;
        switch (i) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/ideas');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/leaderboard');
            break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.create), label: 'Submit'),
        NavigationDestination(icon: Icon(Icons.list), label: 'Ideas'),
        NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Top'),
      ],
    );
  }
}


