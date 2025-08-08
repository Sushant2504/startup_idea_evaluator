import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import '../../domain/entities/idea.dart';
import '../bloc/idea_cubit.dart';

class IdeaListingScreen extends StatefulWidget {
  const IdeaListingScreen({super.key});

  @override
  State<IdeaListingScreen> createState() => _IdeaListingScreenState();
}

class _IdeaListingScreenState extends State<IdeaListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideas'),
        actions: [
          PopupMenuButton<SortMode>(
            onSelected: (m) => context.read<IdeaCubit>().changeSort(m),
            itemBuilder: (c) => const [
              PopupMenuItem(value: SortMode.rating, child: Text('Sort by rating')),
              PopupMenuItem(value: SortMode.votes, child: Text('Sort by votes')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<IdeaCubit, IdeaState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.ideas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline,
                      size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                  const SizedBox(height: 12),
                  const Text('No ideas yet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  const SizedBox(height: 4),
                  const Text('Submit your first idea from the Submit tab'),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.ideas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _AnimatedSlideIn(
              delay: i * 60,
              child: _IdeaCard(idea: state.ideas[i]),
            ),
          );
        },
      ),
      bottomNavigationBar: const _BottomNav(current: 1),
    );
  }
}

class _IdeaCard extends StatefulWidget {
  final IdeaEntity idea;
  const _IdeaCard({required this.idea});

  @override
  State<_IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<_IdeaCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final idea = widget.idea;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(idea.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(idea.tagline, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                _RatingChip(rating: idea.rating),
              ],
            ),
            const SizedBox(height: 8),
            if (expanded)
              Text(idea.description)
            else
              Text(
                idea.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => expanded = !expanded),
                  child: Text(expanded ? 'Read less' : 'Read more'),
                ),
                Row(
                  children: [
                    Chip(label: Text('${idea.votes} votes')),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await context.read<IdeaCubit>().upvote(idea.id);
                        showToast('Thanks for voting 👍');
                      },
                      icon: const Icon(Icons.thumb_up),
                      label: const Text('Upvote'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final int rating;
  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (rating >= 80) {
      color = Colors.green;
    } else if (rating >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    return Chip(label: Text('$rating/100'), side: BorderSide(color: color));
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

class _AnimatedSlideIn extends StatefulWidget {
  final Widget child;
  final int delay; // ms
  const _AnimatedSlideIn({required this.child, this.delay = 0});

  @override
  State<_AnimatedSlideIn> createState() => _AnimatedSlideInState();
}

class _AnimatedSlideInState extends State<_AnimatedSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _offset = Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.delay), _controller.forward);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}


