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
            tooltip: 'Toggle Theme',
            icon: Icon(
              themeCubit.state == ThemeMode.dark 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
            ),
            onPressed: () => themeCubit.toggle(),
          ),
          IconButton(
            tooltip: 'Leaderboard',
            icon: const Icon(Icons.emoji_events),
            onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
          ),
        ],
      ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated Welcome Section
                  _AnimatedWelcomeSection(),
                  const SizedBox(height: 24),
                  
                  // Animated Form Card
                  _AnimatedFormCard(
                    formKey: _formKey,
                    nameController: _nameController,
                    taglineController: _taglineController,
                    descController: _descController,
                    onSubmit: () async {
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
                ],
              ),
            ),
          );
        },
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

class _AnimatedWelcomeSection extends StatefulWidget {
  @override
  State<_AnimatedWelcomeSection> createState() => _AnimatedWelcomeSectionState();
}

class _AnimatedWelcomeSectionState extends State<_AnimatedWelcomeSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark 
                  ? AppGradients.darkPrimary 
                  : AppGradients.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (Theme.of(context).brightness == Brightness.dark 
                      ? AppGradients.darkOrange 
                      : AppGradients.primaryOrange).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Startup Idea Evaluator',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Submit your idea and get AI-powered feedback!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _AnimatedFeatureChip(
                      icon: Icons.psychology,
                      label: 'AI Rating',
                      delay: 200,
                    ),
                    const SizedBox(width: 8),
                    _AnimatedFeatureChip(
                      icon: Icons.thumb_up,
                      label: 'Vote',
                      delay: 400,
                    ),
                    const SizedBox(width: 8),
                    _AnimatedFeatureChip(
                      icon: Icons.leaderboard,
                      label: 'Leaderboard',
                      delay: 600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedFeatureChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final int delay;

  const _AnimatedFeatureChip({
    required this.icon,
    required this.label,
    required this.delay,
  });

  @override
  State<_AnimatedFeatureChip> createState() => _AnimatedFeatureChipState();
}

class _AnimatedFeatureChipState extends State<_AnimatedFeatureChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedFormCard extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController taglineController;
  final TextEditingController descController;
  final VoidCallback onSubmit;

  const _AnimatedFormCard({
    required this.formKey,
    required this.nameController,
    required this.taglineController,
    required this.descController,
    required this.onSubmit,
  });

  @override
  State<_AnimatedFormCard> createState() => _AnimatedFormCardState();
}

class _AnimatedFormCardState extends State<_AnimatedFormCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _cardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _cardScaleAnimation,
          child: Card(
            elevation: 8,
            shadowColor: (Theme.of(context).brightness == Brightness.dark 
                ? AppGradients.darkOrange 
                : AppGradients.primaryOrange).withOpacity(0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          AppGradients.darkCardBackground,
                          AppGradients.darkSurface,
                        ]
                      : [
                          AppGradients.cardBackground,
                          AppGradients.lightBackground,
                        ],
                ),
              ),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnimatedFormField(
                      controller: widget.nameController,
                      label: 'Startup Name',
                      icon: Icons.business,
                      delay: 100,
                    ),
                    const SizedBox(height: 16),
                    _AnimatedFormField(
                      controller: widget.taglineController,
                      label: 'Tagline',
                      icon: Icons.tag,
                      delay: 200,
                    ),
                    const SizedBox(height: 16),
                    _AnimatedFormField(
                      controller: widget.descController,
                      label: 'Description',
                      icon: Icons.description,
                      maxLines: 4,
                      delay: 300,
                    ),
                    const SizedBox(height: 24),
                    _AnimatedSubmitButton(
                      onSubmit: widget.onSubmit,
                      delay: 400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int delay;
  final int maxLines;

  const _AnimatedFormField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.delay,
    this.maxLines = 1,
  });

  @override
  State<_AnimatedFormField> createState() => _AnimatedFormFieldState();
}

class _AnimatedFormFieldState extends State<_AnimatedFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(
              widget.icon, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppGradients.darkOrange 
                  : AppGradients.primaryOrange
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: (Theme.of(context).brightness == Brightness.dark 
                    ? AppGradients.darkOrange 
                    : AppGradients.primaryOrange).withOpacity(0.3)
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: (Theme.of(context).brightness == Brightness.dark 
                    ? AppGradients.darkOrange 
                    : AppGradients.primaryOrange).withOpacity(0.3)
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppGradients.darkOrange 
                    : AppGradients.primaryOrange, 
                width: 2
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark 
                ? AppGradients.darkSurface 
                : Colors.white,
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
      ),
    );
  }
}

class _AnimatedSubmitButton extends StatefulWidget {
  final VoidCallback onSubmit;
  final int delay;

  const _AnimatedSubmitButton({
    required this.onSubmit,
    required this.delay,
  });

  @override
  State<_AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<_AnimatedSubmitButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shimmerController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, _) {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).brightness == Brightness.dark 
                          ? AppGradients.darkOrange 
                          : AppGradients.primaryOrange).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? const [
                            AppGradients.darkOrange,
                            AppGradients.darkTeal,
                            AppGradients.darkBlue,
                          ]
                        : const [
                            AppGradients.primaryOrange,
                            AppGradients.lightOrange,
                            AppGradients.primaryTeal,
                          ],
                    transform:
                        SlidingGradientTransform(_shimmerController.value),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: widget.onSubmit,
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.rocket_launch, color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Submit & Get AI Rating',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


