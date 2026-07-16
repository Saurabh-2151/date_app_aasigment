import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedCategory = 0;

  static const List<String> _categories = ['All', 'Dating', 'Social', 'Adventure', 'Food', 'Music'];

  static const List<Map<String, dynamic>> _events = [
    {
      'title': 'Speed Dating Night',
      'category': 'Dating',
      'date': 'Sat, Jan 18',
      'time': '7:00 PM',
      'location': 'The Social Club, NYC',
      'image': 'https://images.unsplash.com/photo-1529543544282-ea669407fca3?w=400',
      'attendees': 24,
      'price': '\$15',
      'color': 0xFFE91E63,
    },
    {
      'title': 'Singles Rooftop Mixer',
      'category': 'Social',
      'date': 'Sun, Jan 19',
      'time': '6:30 PM',
      'location': 'Sky Lounge, Manhattan',
      'image': 'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=400',
      'attendees': 48,
      'price': '\$20',
      'color': 0xFF9C27B0,
    },
    {
      'title': 'Couples Cooking Class',
      'category': 'Food',
      'date': 'Fri, Jan 24',
      'time': '5:00 PM',
      'location': 'Chef\'s Kitchen, Brooklyn',
      'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
      'attendees': 16,
      'price': '\$35',
      'color': 0xFFFF9800,
    },
    {
      'title': 'Hiking & Connections',
      'category': 'Adventure',
      'date': 'Sat, Jan 25',
      'time': '8:00 AM',
      'location': 'Bear Mountain, NY',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400',
      'attendees': 32,
      'price': 'Free',
      'color': 0xFF4CAF50,
    },
    {
      'title': 'Jazz & Romance Evening',
      'category': 'Music',
      'date': 'Fri, Jan 31',
      'time': '8:30 PM',
      'location': 'Blue Note Jazz Club',
      'image': 'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?w=400',
      'attendees': 60,
      'price': '\$25',
      'color': 0xFF3F51B5,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0) return _events;
    final cat = _categories[_selectedCategory];
    return _events.where((e) => e['category'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildFeaturedBanner()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Upcoming Events', style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _EventCard(event: _filtered[i]),
                childCount: _filtered.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Events', style: Theme.of(context).textTheme.headlineMedium),
          IconButton(
            icon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20,
            child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)))),
          Positioned(right: 20, bottom: -30,
            child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Text('⭐ Featured', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                const Text('Valentine\'s Speed\nDating Gala', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, height: 1.2)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 13),
                  const SizedBox(width: 4),
                  const Text('Feb 14 • 7:00 PM', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(width: 12),
                  const Icon(Icons.people_outline_rounded, color: Colors.white70, size: 13),
                  const SizedBox(width: 4),
                  const Text('120 attending', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _selectedCategory = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _selectedCategory == i ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _selectedCategory == i ? AppColors.primary : AppColors.divider),
            ),
            child: Text(_categories[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _selectedCategory == i ? Colors.white : AppColors.textSecondary)),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(event['image'], height: 150, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 150, color: Color(event['color'] as int).withValues(alpha: 0.3))),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Color(event['color'] as int), borderRadius: BorderRadius.circular(12)),
                    child: Text(event['category'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                    child: Text(event['price'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${event['date']} • ${event['time']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(child: Text(event['location'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${event['attendees']} attending', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ]),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Join', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
