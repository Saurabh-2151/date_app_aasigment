import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AdmirersScreen extends StatefulWidget {
  const AdmirersScreen({super.key});

  @override
  State<AdmirersScreen> createState() => _AdmirersScreenState();
}

class _AdmirersScreenState extends State<AdmirersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, dynamic>> _likes = [
    {'name': 'Mia', 'age': 25, 'city': 'Boston', 'image': 'https://randomuser.me/api/portraits/women/12.jpg', 'time': '2m ago'},
    {'name': 'Zoe', 'age': 27, 'city': 'Denver', 'image': 'https://randomuser.me/api/portraits/women/23.jpg', 'time': '15m ago'},
    {'name': 'Lily', 'age': 24, 'city': 'Austin', 'image': 'https://randomuser.me/api/portraits/women/34.jpg', 'time': '1h ago'},
    {'name': 'Chloe', 'age': 26, 'city': 'Portland', 'image': 'https://randomuser.me/api/portraits/women/45.jpg', 'time': '3h ago'},
    {'name': 'Grace', 'age': 28, 'city': 'Nashville', 'image': 'https://randomuser.me/api/portraits/women/56.jpg', 'time': '5h ago'},
    {'name': 'Nora', 'age': 23, 'city': 'Phoenix', 'image': 'https://randomuser.me/api/portraits/women/67.jpg', 'time': '1d ago'},
  ];

  static const List<Map<String, dynamic>> _roses = [
    {'name': 'Aria', 'age': 26, 'city': 'San Diego', 'image': 'https://randomuser.me/api/portraits/women/78.jpg', 'time': '30m ago', 'msg': 'You seem really interesting!'},
    {'name': 'Luna', 'age': 25, 'city': 'Atlanta', 'image': 'https://randomuser.me/api/portraits/women/89.jpg', 'time': '2h ago', 'msg': 'Your smile is amazing 🌹'},
    {'name': 'Stella', 'age': 29, 'city': 'Minneapolis', 'image': 'https://randomuser.me/api/portraits/women/90.jpg', 'time': '1d ago', 'msg': 'Would love to chat!'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLikesGrid(),
                  _buildRosesList(),
                ],
              ),
            ),
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
          Text('Admirers', style: Theme.of(context).textTheme.headlineMedium),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: AppColors.primary, size: 14),
                const SizedBox(width: 4),
                Text('${_likes.length + _roses.length} new', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        tabs: [
          Tab(text: 'Likes (${_likes.length})'),
          Tab(text: 'Roses (${_roses.length})'),
        ],
      ),
    );
  }

  Widget _buildLikesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: _likes.length,
      itemBuilder: (_, i) => _LikeCard(profile: _likes[i]),
    );
  }

  Widget _buildRosesList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _roses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _RoseCard(profile: _roses[i]),
    );
  }
}

class _LikeCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _LikeCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(profile['image'], fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.textHint)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0],
                colors: [Colors.transparent, Color(0xCC000000)],
              ),
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
              child: Text(profile['time'], style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ),
          ),
          Positioned(
            bottom: 10, left: 10, right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${profile['name']}, ${profile['age']}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                Row(children: [
                  const Icon(Icons.location_on_outlined, color: Colors.white70, size: 11),
                  const SizedBox(width: 2),
                  Text(profile['city'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoseCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _RoseCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(profile['image'], width: 70, height: 70, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: AppColors.textHint)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${profile['name']}, ${profile['age']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(profile['time'], style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textSecondary),
                  const SizedBox(width: 2),
                  Text(profile['city'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text('🌹', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 5),
                      Expanded(child: Text(profile['msg'], style: const TextStyle(fontSize: 12, color: AppColors.primary, fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
