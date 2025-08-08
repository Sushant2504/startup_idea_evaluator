import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

import '../../presentation/bloc/idea_cubit.dart';
import '../../presentation/bloc/theme_cubit.dart';
import '../styles/gradients.dart';

class IdeaSubmissionScreen extends StatefulWidget {
  const IdeaSubmissionScreen({super.key});

  @override
  State<IdeaSubmissionScreen> createState() => _IdeaSubmissionScreenState();
}

class _IdeaSubmissionScreenState extends State<IdeaSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Idea'),
        actions: [
          IconButton(
            tooltip: 'Toggle Dark Mode',
            icon: const Icon(Icons.dark_mode),
            onPressed: () => themeCubit.toggle(),
          ),
          IconButton(
            tooltip: 'Leaderboard',
            icon: const Icon(Icons.emoji_events),
            onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppGradients.hushhSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('The Startup Idea Evaluator 🚀', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Submit your idea, get a fun AI rating, and compete on the leaderboard!'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Startup Name'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _taglineController,
                        decoration: const InputDecoration(labelText: 'Tagline'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descController,
                        maxLines: 5,
                        decoration: const InputDecoration(labelText: 'Description'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.send),
                          label: const Text('Submit & Get AI Rating'),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            await context.read<IdeaCubit>().submitIdea(
                                  name: _nameController.text.trim(),
                                  tagline: _taglineController.text.trim(),
                                  description: _descController.text.trim(),
                                );
                            if (!mounted) return;
                            showToast('Idea submitted! 🎉');
                            Navigator.pushReplacementNamed(context, '/ideas');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(current: 0),
    );
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


