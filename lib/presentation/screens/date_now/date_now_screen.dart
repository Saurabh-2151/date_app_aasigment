import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ─── Model ──────────────────────────────────────────────────────────────────

enum DateSlot { today, tomorrow, weekend }

class DatePlan {
  final String liveLabel; // e.g. "Live · Olive Bar, Mahalaxmi"
  final String distance; // e.g. "3.4 km away"
  final String image;
  final DateSlot slot;
  final String time; // e.g. "8:30 PM"
  final String type; // e.g. "Dinner"
  final String title; // e.g. "Pasta & Honest Chats"
  final String description;
  final String matchPercent; // e.g. "88% match"
  final String groupSize; // e.g. "Just 1"
  final String payLabel; // e.g. "I'll pay"
  final String userAvatar;
  final String userName;
  final int userAge;
  final bool verified;
  final String userMeta; // e.g. "she/her · Foodie"

  const DatePlan({
    required this.liveLabel,
    required this.distance,
    required this.image,
    required this.slot,
    required this.time,
    required this.type,
    required this.title,
    required this.description,
    required this.matchPercent,
    required this.groupSize,
    required this.payLabel,
    required this.userAvatar,
    required this.userName,
    required this.userAge,
    required this.verified,
    required this.userMeta,
  });
}

class DateNowScreen extends StatefulWidget {
  const DateNowScreen({super.key});

  @override
  State<DateNowScreen> createState() => _DateNowScreenState();
}

class _DateNowScreenState extends State<DateNowScreen> {
  DateSlot _slot = DateSlot.today;
  int _currentIndex = 0;
  int _plansCount = 2; // badge on "My Plans"

  static const List<DatePlan> _plans = [
    DatePlan(
      liveLabel: 'Live · Olive Bar, Mahalaxmi',
      distance: '3.4 km away',
      image: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      slot: DateSlot.today,
      time: '8:30 PM',
      type: 'Dinner',
      title: 'Pasta & Honest Chats',
      description: 'Foodie looking for a dinner buddy 🍝',
      matchPercent: '88% match',
      groupSize: 'Just 1',
      payLabel: "I'll pay",
      userAvatar: 'https://randomuser.me/api/portraits/women/44.jpg',
      userName: 'Ananya',
      userAge: 25,
      verified: true,
      userMeta: 'she/her · Foodie',
    ),
    DatePlan(
      liveLabel: 'Live · Social, Bandra',
      distance: '5.1 km away',
      image: 'https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=800',
      slot: DateSlot.today,
      time: '9:00 PM',
      type: 'Drinks',
      title: 'Cocktails & Bad Jokes',
      description: 'Looking for someone to laugh with 🍸',
      matchPercent: '76% match',
      groupSize: 'Just 1',
      payLabel: 'Splitting',
      userAvatar: 'https://randomuser.me/api/portraits/women/65.jpg',
      userName: 'Emma',
      userAge: 24,
      verified: true,
      userMeta: 'she/her · Traveler',
    ),
    DatePlan(
      liveLabel: 'Live · Cafe Zoe, Lower Parel',
      distance: '2.2 km away',
      image: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      slot: DateSlot.tomorrow,
      time: '5:00 PM',
      type: 'Coffee',
      title: 'Coffee & Slow Sundays',
      description: 'Bookworm seeking a coffee companion 📚',
      matchPercent: '91% match',
      groupSize: 'Just 1',
      payLabel: "I'll pay",
      userAvatar: 'https://randomuser.me/api/portraits/women/32.jpg',
      userName: 'Olivia',
      userAge: 28,
      verified: false,
      userMeta: 'she/her · Reader',
    ),
    DatePlan(
      liveLabel: 'Live · Marine Drive',
      distance: '6.8 km away',
      image: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800',
      slot: DateSlot.weekend,
      time: '7:00 AM',
      type: 'Walk',
      title: 'Sunrise & Small Talk',
      description: 'Early riser looking for a walk buddy 🌅',
      matchPercent: '82% match',
      groupSize: 'Just 1',
      payLabel: 'No pay needed',
      userAvatar: 'https://randomuser.me/api/portraits/women/17.jpg',
      userName: 'Ava',
      userAge: 25,
      verified: true,
      userMeta: 'she/her · Fitness',
    ),
  ];

  List<DatePlan> get _filtered =>
      _plans.where((p) => p.slot == _slot).toList();

  void _next() {
    final list = _filtered;
    if (_currentIndex < list.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _skip() => _next();

  void _requestDate() {
    setState(() => _plansCount++);
    _next();
  }

  void _selectSlot(DateSlot slot) {
    setState(() {
      _slot = slot;
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final plan = list.isNotEmpty
        ? list[_currentIndex.clamp(0, list.length - 1)]
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            _buildSlotTabs(),
            const SizedBox(height: 14),
            Expanded(
              child: plan == null
                  ? const Center(
                      child: Text(
                        'No plans in this slot yet',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : _buildCard(context, plan),
            ),
            const SizedBox(height: 14),
            if (plan != null) _buildActions(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: (Theme.of(context).textTheme.headlineMedium ??
                      const TextStyle())
                  .copyWith(fontWeight: FontWeight.w700),
              children: const [
                TextSpan(text: 'Date ', style: TextStyle(color: Colors.black)),
                TextSpan(text: 'Now', style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
          _MyPlansButton(count: _plansCount, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildSlotTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _SlotChip(
              label: 'Today',
              selected: _slot == DateSlot.today,
              onTap: () => _selectSlot(DateSlot.today),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SlotChip(
              label: 'Tomorrow',
              selected: _slot == DateSlot.tomorrow,
              onTap: () => _selectSlot(DateSlot.tomorrow),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SlotChip(
              label: 'Weekend',
              selected: _slot == DateSlot.weekend,
              onTap: () => _selectSlot(DateSlot.weekend),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, DatePlan plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              plan.image,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, p) => p == null
                  ? child
                  : Container(
                      color: AppColors.textHint,
                      child: const Center(
                          child: CircularProgressIndicator(color: AppColors.primary)),
                    ),
              errorBuilder: (_, __, ___) => Container(color: AppColors.textHint),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.35, 1.0],
                  colors: [Colors.transparent, Color(0xEE000000)],
                ),
              ),
            ),
            // Top-left: live + distance badges
            Positioned(
              top: 14,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  Flexible(
                    child: _InfoPill(
                      color: const Color(0xFF1F8B4C).withValues(alpha: 0.85),
                      leading: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      label: plan.liveLabel,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 46,
              left: 14,
              child: _InfoPill(
                color: Colors.black.withValues(alpha: 0.45),
                icon: Icons.location_on_rounded,
                label: plan.distance,
              ),
            ),
            // Report flag
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_outlined, color: Colors.white70, size: 14),
              ),
            ),
            // Bottom content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          plan.slot == DateSlot.today
                              ? 'TODAY'
                              : plan.slot == DateSlot.tomorrow
                                  ? 'TOMORROW'
                                  : 'WEEKEND',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _InfoPill(
                        color: Colors.white.withValues(alpha: 0.18),
                        icon: Icons.access_time_rounded,
                        label: plan.time,
                      ),
                      const SizedBox(width: 8),
                      _InfoPill(
                        color: Colors.white.withValues(alpha: 0.18),
                        icon: Icons.restaurant_rounded,
                        label: plan.type,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plan.title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: _InfoPill(
                          color: const Color(0xFF7A4FE0).withValues(alpha: 0.55),
                          icon: Icons.favorite_rounded,
                          label: plan.matchPercent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _InfoPill(
                          color: Colors.white.withValues(alpha: 0.18),
                          icon: Icons.people_alt_rounded,
                          label: plan.groupSize,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _InfoPill(
                          color: Colors.white.withValues(alpha: 0.18),
                          icon: Icons.savings_rounded,
                          label: plan.payLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(plan.userAvatar),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${plan.userName}, ${plan.userAge}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  if (plan.verified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded,
                                        color: AppColors.primary, size: 14),
                                  ],
                                ],
                              ),
                              Text(
                                plan.userMeta,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Profile',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 2),
                              Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.primary, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _skip,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text('Skip',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _requestDate,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Request Date',
                        style: TextStyle(
                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── My Plans button (pink pill + badge) ───────────────────────────────────

class _MyPlansButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _MyPlansButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 15),
            const SizedBox(width: 6),
            const Text('My Plans',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 18),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Slot tab chip (Today / Tomorrow / Weekend) ────────────────────────────

class _SlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SlotChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.selected : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Small pill used inside the card overlay ───────────────────────────────

class _InfoPill extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final Widget? leading;
  final String label;
  const _InfoPill({required this.color, this.icon, this.leading, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) leading!,
          if (icon != null) Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 5),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}