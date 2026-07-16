import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app_assignment/presentation/screens/home/notification_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/rose_bottom_sheet.dart';

const _kCardRadius = 22.0;
const _kCardMarginH = 1.0;
const _kSectionRadius = 20.0;
const _kCardPad = 18.0;

// ─── HomePage ─────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  final List<UserModel> users;
  final int currentIndex;
  final VoidCallback onSwipe;
  final Future<void> Function() onRefresh;

  const HomePage({
    super.key,
    required this.users,
    required this.currentIndex,
    required this.onSwipe,
    required this.onRefresh,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _isAnimatingOut = false;

  static const double _swipeThreshold = 100.0;
  static const double _maxRotation = 0.15;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_swipeController);
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails _) {
    if (_isAnimatingOut) return;
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimatingOut) return;
    setState(() => _dragOffset += Offset(details.delta.dx, 0));
  }

  void _onPanEnd(DragEndDetails _) {
    if (_isAnimatingOut) return;
    if (_dragOffset.dx.abs() > _swipeThreshold) {
      _animateOut(_dragOffset.dx > 0);
    } else {
      _snapBack();
    }
  }

  void _animateOut(bool toRight) {
    _isAnimatingOut = true;
    final w = MediaQuery.of(context).size.width;
    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(toRight ? w * 1.5 : -w * 1.5, _dragOffset.dy),
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));
    _swipeController.forward(from: 0).then((_) {
      _swipeController.reset();
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
        _isAnimatingOut = false;
      });
      widget.onSwipe();
    });
  }

  void _snapBack() {
    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.elasticOut));
    _swipeController.forward(from: 0).then((_) {
      _swipeController.reset();
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
    });
  }

  Offset get _currentOffset {
    if (_isAnimatingOut || (_swipeController.isAnimating && !_isDragging)) {
      return _swipeAnimation.value;
    }
    return _dragOffset;
  }

  double get _dragProgress =>
      (_currentOffset.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);

  // ─── Navigation ────────────────────────────────────────────────────────

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = widget.users;
    if (users.isEmpty) return const Scaffold(body: SizedBox.shrink());
    final user = users[widget.currentIndex % users.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const _HeaderBtn(icon: Icons.menu_rounded),
                const Spacer(),
                const _Daily25Pill(),
                const SizedBox(width: 8),
                const _HeaderBtn(icon: Icons.bolt_rounded),
                const SizedBox(width: 8),
                const _HeaderBtn(icon: Icons.tune_rounded),
                const SizedBox(width: 8),
                _HeaderBtn(
                  icon: Icons.notifications_none_rounded,
                  showBadge: true,
                  onTap: _openNotifications,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: widget.onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildCardStack(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(child: _buildStatChipsRow(user)),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(child: _buildAbout(user)),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildBasics(user)),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildVideoIntro()),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildPromptCard(0)),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(child: _buildCareer()),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildImageCard(user)),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildPromptCard(1)),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(child: _buildInterests()),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(child: _buildLifestyle()),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildDatingGoal()),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(child: _buildImageCard(user, alt: true)),
              _floatingRose(),
              SliverToBoxAdapter(child: _buildPromptCard(2)),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Card Stack (unchanged swipe mechanic) ─────────────────────────────────

  Widget _buildCardStack(BuildContext context) {
    final users = widget.users;
    final n = users.length;
    final cardH = MediaQuery.of(context).size.height * 0.81;

    final cards = <Widget>[];
    for (int i = 2; i >= 0; i--) {
      final user = users[(widget.currentIndex + i) % n];
      cards.add(i == 0 ? _topCard(context, user, cardH) : _backCard(context, user, i, cardH));
    }

    return SizedBox(
      height: cardH + 16,
      child: Stack(alignment: Alignment.topCenter, children: cards),
    );
  }

  Widget _backCard(BuildContext context, UserModel user, int depth, double cardH) {
    final restScale = depth == 1 ? 0.97 : 0.94;
    final restTY = depth == 1 ? 10.0 : 18.0;

    return AnimatedBuilder(
      animation: _swipeController,
      builder: (_, child) {
        final p = _dragProgress;
        final scale = (restScale + (1.0 - restScale) * p).clamp(0.0, 1.0);
        final ty = restTY * (1.0 - p);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kCardMarginH),
          child: Transform.translate(
            offset: Offset(0, ty),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: _SwipeCard(user: user, cardHeight: cardH),
    );
  }

  Widget _topCard(BuildContext context, UserModel user, double cardH) {
    return AnimatedBuilder(
      animation: _swipeController,
      builder: (_, child) {
        final off = _currentOffset;
        final rot = (off.dx / 400).clamp(-_maxRotation, _maxRotation);
        return Transform.translate(
          offset: off,
          child: Transform.rotate(angle: rot, child: child),
        );
      },
      child: RawGestureDetector(
        gestures: {
          HorizontalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer(),
            (instance) {
              instance
                ..onStart = _onPanStart
                ..onUpdate = _onPanUpdate
                ..onEnd = _onPanEnd;
            },
          ),
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kCardMarginH),
          child: _SwipeCard(user: user, isTop: true, cardHeight: cardH),
        ),
      ),
    );
  }

  // ─── Floating rose divider between blocks ─────────────────────────────────

  Widget _floatingRose() => const SliverToBoxAdapter(child: _FloatingRose());

  // ─── Profile Sections (content mirrors the reference screenshots) ─────────

  Widget _buildStatChipsRow(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: const [
          _StatChip(dotColor: AppColors.blue, label: '92% Match'),
          SizedBox(width: 8),
          _StatChip(dotColor: AppColors.green, label: '98% Trust'),
          SizedBox(width: 8),
          _StatChip(dotColor: AppColors.orange, label: '~5m Replies'),
        ],
      ),
    );
  }

  Widget _buildAbout(UserModel user) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('About'),
          SizedBox(height: 10),
          Text(
            'Building products by day, planning my next trek by night. '
            'Looking for someone equally driven and equally curious.',
            style: TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBasics(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('The Basics'),
          const SizedBox(height: 10),
          _InfoCard(rows: const [
            _InfoRow(icon: Icons.cake_outlined, label: 'Age', value: '21 years old', sub: '19 feb 1999'),
            _InfoRow(icon: Icons.straighten_rounded, label: 'Height', value: '5\'5" (165 cm)'),
            _InfoRow(icon: Icons.hiking_rounded, label: 'Lives in', value: 'Koregaon park', sub: 'Pune, Maharashtra'),
            _InfoRow(icon: Icons.favorite_border_rounded, label: 'Love language', value: 'Compliment', sub: 'Words of affirmation'),
            _InfoRow(icon: Icons.water_drop_outlined, label: 'Religion', value: 'Hindu-Marathi'),
            _InfoRow(icon: Icons.list_alt_rounded, label: 'Interested in', value: 'Women - Dating'),
            _InfoRow(icon: Icons.auto_awesome_outlined, label: 'Zodiac', value: 'Scorpio', sub: 'Loyal · Passionate · Intuitive'),
            _InfoRow(icon: Icons.translate_rounded, label: 'Mother tongue', value: 'Marathi'),
            _InfoRow(icon: Icons.phone_in_talk_outlined, label: 'Communication style', value: 'Phone calls over texts'),
          ]),
        ],
      ),
    );
  }

  Widget _buildVideoIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_kSectionRadius),
        child: SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: const Color(0xFFE8E0D8)),
                errorWidget: (_, __, ___) => Container(color: const Color(0xFFE8E0D8)),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Color(0x99000000), Colors.transparent],
                  ),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 30),
                ),
              ),
              const Positioned(
                left: 14,
                bottom: 12,
                child: Text(
                  'Video Intro · 0:28',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptCard(int index) {
    const prompts = [
      ('The way to win me over is…', 'A good book rec and a strong chai opinion.'),
      ('My simple pleasures…', 'Roadside chai after a long trek, no signal, good company.'),
      ("We'll get along if…", 'You can debate me for an hour and still want dessert after.'),
    ];
    final p = prompts[index % prompts.length];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _PromptCard(label: p.$1, text: p.$2),
    );
  }

  Widget _buildCareer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Career & Ambition'),
          const SizedBox(height: 10),
          _InfoCard(
            rows: const [
              _InfoRow(icon: Icons.school_outlined, label: 'Education', value: 'NIFT Pune', sub: 'B. Des Fashion Design · 3rd year'),
              _InfoRow(icon: Icons.work_outline_rounded, label: 'Work as', value: 'Fashion Design', sub: 'Freelance · 2 yrs exp'),
              _InfoRow(icon: Icons.auto_awesome_outlined, label: 'Work style', value: 'Creative · Hybrid'),
              _InfoRow(icon: Icons.trending_up_rounded, label: 'Ambition level', value: 'HIGHLY DRIVEN'),
            ],
            footerLabel: 'Her Big Dream',
            footerText:
                "Launch her own sustainable Indian fashion label — handcrafted, slow fashion made with heart. "
                'Also wants to travel every fashion capital before 30.',
          ),
        ],
      ),
    );
  }

  Widget _buildInterests() {
    const items = [
      ('Travel', Icons.flight_rounded),
      ('Coffee', Icons.local_cafe_outlined),
      ('Trekking', Icons.terrain_rounded),
      ('Books', Icons.menu_book_outlined),
      ('Yoga', Icons.self_improvement_rounded),
      ('Indie music', Icons.music_note_rounded),
      ('Cooking', Icons.favorite_border_rounded),
      ('Photography', Icons.camera_alt_outlined),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Interests & Hobbies'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((e) => _HobbyChip(icon: e.$2, label: e.$1)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Lifestyle'),
          const SizedBox(height: 10),
          _InfoCard(rows: const [
            _InfoRow(icon: Icons.restaurant_menu_rounded, label: 'Diet', value: 'Vegetarian'),
            _InfoRow(icon: Icons.wine_bar_outlined, label: 'Drinking', value: 'Socially'),
            _InfoRow(icon: Icons.smoke_free_rounded, label: 'Smoking', value: 'Non-smoker'),
            _InfoRow(icon: Icons.show_chart_rounded, label: 'Fitness', value: 'Gym 4x/week', sub: 'Yoga · Trekking'),
            _InfoRow(icon: Icons.travel_explore_rounded, label: 'Travel', value: '4-5 trips/year'),
            _InfoRow(icon: Icons.pets_rounded, label: 'Pets', value: 'Cat parent'),
            _InfoRow(icon: Icons.dark_mode_outlined, label: 'Sleep', value: 'Night Owl'),
          ]),
        ],
      ),
    );
  }

  Widget _buildDatingGoal() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _DatingGoalCard(
        title: 'Long-term, marriage-open',
        description:
            'No pressure, no timelines — just looking for the right person to build something real with.',
      ),
    );
  }

  Widget _buildImageCard(UserModel user, {bool alt = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_kCardRadius),
        child: SizedBox(
          height: 320,
          child: CachedNetworkImage(
            imageUrl: alt
                ? 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=800'
                : user.picture.large,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            placeholder: (_, __) => Container(color: const Color(0xFFE8E0D8)),
            errorWidget: (_, __, ___) => Container(
              color: const Color(0xFFE8E0D8),
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Swipe Card (unchanged) ───────────────────────────────────────────────────

class _SwipeCard extends StatelessWidget {
  final UserModel user;
  final bool isTop;
  final double cardHeight;
  const _SwipeCard({required this.user, this.isTop = false, required this.cardHeight});

  static const _professions = ['Software Engineer', 'Product Designer', 'Marketing Manager', 'Doctor', 'Architect', 'Photographer', 'Teacher', 'Entrepreneur'];
  static const _goals = ['Long-term relationship', 'Something casual', 'Marriage', 'Still figuring it out', 'New friends'];

  String get _profession => _professions[user.name.first.codeUnitAt(0) % _professions.length];
  String get _goal => _goals[user.name.last.codeUnitAt(0) % _goals.length];
  int get _match => 70 + (user.name.first.codeUnitAt(0) % 28);
  int get _trust => 75 + (user.name.last.codeUnitAt(0) % 22);
  String get _reply {
    const t = ['< 1 hr', '< 2 hrs', 'A few hours', 'Same day'];
    return t[user.dob.age % t.length];
  }
  double get _dist => 1.0 + (user.name.first.codeUnitAt(0) % 30) + 0.5;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_kCardRadius),
      child: SizedBox(
        height: cardHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: user.picture.large,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              placeholder: (_, __) => Container(
                color: const Color(0xFFE8E0D8),
                child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              ),
              errorWidget: (_, __, ___) => Container(
                color: const Color(0xFFE8E0D8),
                child: const Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Color(0x99000000), Colors.transparent],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  stops: [0.0, 0.55],
                  colors: [Color(0xB3000000), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _CardIconBtn(icon: Icons.refresh),
                  _CardIconBtn(icon: Icons.more_vert_outlined),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 70, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _CardChip(icon: Icons.circle, text: '$_match% Match', color: AppColors.blue),
                        _CardChip(icon: Icons.circle, text: '$_trust% Trust', color: AppColors.green),
                        _CardChip(icon: Icons.circle, text: _reply, color: AppColors.orange),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 10, color: AppColors.green),
                        const SizedBox(width: 8),
                        Text(user.name.first,
                            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
                        const SizedBox(width: 8),
                        Text('${user.dob.age}',
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    _CardMeta(
                        icon: Icons.location_on,
                        text: '${user.location.city}, ${user.location.country}  •  ${_dist.toStringAsFixed(1)} km'),
                    const SizedBox(height: 3),
                    _CardMeta(icon: Icons.work_outline_rounded, text: _profession),
                    const SizedBox(height: 3),
                    _CardMeta(icon: Icons.favorite, text: _goal),
                  ],
                ),
              ),
            ),
            if (isTop)
              Positioned(
                bottom: 22,
                right: 18,
                child: _RoseBtn(user: user),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── New: Section label (pink caps) ────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: 1.3,
        ),
      );
}

// ─── New: Match/Trust/Reply stat chip (white pill) ─────────────────────────

class _StatChip extends StatelessWidget {
  final Color dotColor;
  final String label;
  const _StatChip({required this.dotColor, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: dotColor),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      );
}

// ─── New: Info table row + card (Basics / Career / Lifestyle) ─────────────

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  const _InfoRow({required this.icon, required this.label, required this.value, this.sub});
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  final String? footerLabel;
  final String? footerText;
  const _InfoCard({required this.rows, this.footerLabel, this.footerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _kCardPad, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_kSectionRadius),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _buildRow(rows[i]),
            if (i != rows.length - 1) const Divider(height: 1, color: AppColors.divider),
          ],
          if (footerLabel != null) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(footerLabel!),
                  const SizedBox(height: 8),
                  Text(footerText ?? '',
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(_InfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(row.icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(row.label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(row.value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              if (row.sub != null) ...[
                const SizedBox(height: 2),
                Text(row.sub!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textHint)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── New: Prompt card with embedded mini rose ──────────────────────────────

class _PromptCard extends StatelessWidget {
  final String label;
  final String text;
  const _PromptCard({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(_kCardPad),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(_kSectionRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(label),
                const SizedBox(height: 10),
                Text(text,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.4)),
                const SizedBox(height: 18),
              ],
            ),
          ),
          const Positioned(bottom: -14, left: 16, child: _MiniRose()),
        ],
      ),
    );
  }
}

class _MiniRose extends StatelessWidget {
  const _MiniRose();

  @override
  Widget build(BuildContext context) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: const Center(child: Text('🌹', style: TextStyle(fontSize: 14))),
      );
}

// ─── New: Floating rose between sections ───────────────────────────────────

class _FloatingRose extends StatelessWidget {
  const _FloatingRose();

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(0, -8),
        child: Padding(
          padding: const EdgeInsets.only(right: 24, bottom: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.selected,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Center(child: Text('🌹', style: TextStyle(fontSize: 16))),
            ),
          ),
        ),
      );
}

// ─── New: Hobby chip (light pink pill) ─────────────────────────────────────

class _HobbyChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HobbyChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.selected,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      );
}

// ─── New: Dating Goal (solid pink card) ────────────────────────────────────

class _DatingGoalCard extends StatelessWidget {
  final String title;
  final String description;
  const _DatingGoalCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_kCardPad),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(_kSectionRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DATING GOAL',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.75),
                  letterSpacing: 1.3)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 6),
          Text(description,
              style: TextStyle(fontSize: 13.5, color: Colors.white.withValues(alpha: 0.9), height: 1.5)),
        ],
      ),
    );
  }
}

// ─── Header Widgets ───────────────────────────────────────────────────────────

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final bool showBadge;
  final VoidCallback? onTap;
  const _HeaderBtn({required this.icon, this.showBadge = false, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Icon(icon, size: 20, color: AppColors.textPrimary),
            ),
            if (showBadge)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      );
}

class _Daily25Pill extends StatelessWidget {
  const _Daily25Pill();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.circle, size: 8, color: Color(0xFFFF4D6D)),
            SizedBox(width: 4),
            Text('Daily 25', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      );
}

// ─── Card Widgets (unchanged) ─────────────────────────────────────────────────

class _CardIconBtn extends StatelessWidget {
  final IconData icon;
  const _CardIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      );
}

class _CardChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _CardChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _CardMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: Colors.white60, size: 13),
          const SizedBox(width: 5),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );
}

// ─── Rose Button (unchanged) ──────────────────────────────────────────────────

class _RoseBtn extends StatelessWidget {
  final UserModel user;
  const _RoseBtn({required this.user});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => showRoseBottomSheet(context, user),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(child: Text('🌹', style: TextStyle(fontSize: 22))),
        ),
      );
}