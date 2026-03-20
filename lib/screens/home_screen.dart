import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/baby_provider.dart';
import '../widgets/add_activity_sheet.dart';
import '../widgets/banner_ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Genel', 'Mama', 'Uyku', 'Bez'];

  @override
  Widget build(BuildContext context) {
    final baby = context.watch<BabyProvider>();
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM y', 'tr').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(baby, dateStr),
            _buildTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    _buildNextFeedingCard(baby),
                    const SizedBox(height: 10),
                    _buildStatsRow(baby),
                    const SizedBox(height: 14),
                    const Text('Son aktiviteler',
                        style: TextStyle(fontSize: 11, color: Color(0xFF555555), letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    _buildTimeline(baby),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF16161E),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => const AddActivitySheet(),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BabyProvider baby, String dateStr) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BebeCare', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white)),
            Text(dateStr, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
          ]),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Center(
              child: Text(
                baby.babyName.isNotEmpty ? baby.babyName[0].toUpperCase() : 'B',
                style: const TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16161E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: List.generate(_tabs.length, (i) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedTab == i ? const Color(0xFF1E1B4B) : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  _tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: _selectedTab == i ? FontWeight.w500 : FontWeight.normal,
                    color: _selectedTab == i ? const Color(0xFFA78BFA) : const Color(0xFF666666),
                  ),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildNextFeedingCard(BabyProvider baby) {
    final next = baby.nextFeedingTime;
    final now = DateTime.now();
    String timeStr = '--:--';
    String subStr = 'Henüz kayıt yok';
    if (next != null) {
      timeStr = DateFormat('HH:mm').format(next);
      final diff = next.difference(now);
      if (diff.isNegative) {
        subStr = 'Mama vakti geçti!';
      } else {
        final h = diff.inHours;
        final m = diff.inMinutes % 60;
        subStr = h > 0 ? '$h sa $m dk sonra' : '$m dk sonra';
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1730),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4C3A99), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2A1F4A),
              borderRadius: BorderRadius.circular(21),
            ),
            child: const Icon(Icons.access_time, color: Color(0xFFA78BFA), size: 20),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Sonraki mama', style: TextStyle(fontSize: 12, color: Color(0xFFCCCCCC))),
            const SizedBox(height: 2),
            Text(timeStr, style: const TextStyle(fontSize: 20, color: Color(0xFFA78BFA), fontWeight: FontWeight.w500)),
            Text(subStr, style: const TextStyle(fontSize: 10, color: Color(0xFF555555))),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BabyProvider baby) {
    return Row(
      children: [
        _statCard('Bugün mama', '${baby.todayFeedingMl.toInt()} ml'),
        const SizedBox(width: 8),
        _statCard('Uyku', '${baby.todaySleepHours.toStringAsFixed(1)} sa'),
        const SizedBox(width: 8),
        _statCard('Bez', '${baby.todayDiaperCount} ad'),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF16161E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A35), width: 0.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF555555))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
        ]),
      ),
    );
  }

  Widget _buildTimeline(BabyProvider baby) {
    final activities = baby.todayActivities;
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF16161E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A35), width: 0.5),
        ),
        child: const Center(
          child: Text('Bugün henüz aktivite yok.\nAşağıdaki + butonuna bas!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF555555), fontSize: 13, height: 1.6)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16161E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A35), width: 0.5),
      ),
      child: Column(
        children: activities.take(10).map((a) => _timelineItem(a)).toList(),
      ),
    );
  }

  Widget _timelineItem(Activity a) {
    Color dotColor;
    String title;
    String subtitle;

    switch (a.type) {
      case ActivityType.feeding:
        dotColor = const Color(0xFFA78BFA);
        final ml = a.details['amount_ml'] ?? 0;
        final type = a.details['feeding_type'] == 0 ? 'Emzirme' : 'Biberon';
        title = ml > 0 ? '$type · $ml ml' : type;
        subtitle = 'Mama';
        break;
      case ActivityType.sleep:
        dotColor = const Color(0xFF34D399);
        final min = a.details['duration_min'] ?? 0;
        final h = min ~/ 60;
        final m = min % 60;
        title = h > 0 ? '$h sa $m dk uyudu' : '$m dk uyudu';
        subtitle = 'Uyku';
        break;
      case ActivityType.diaper:
        dotColor = const Color(0xFFFBBF24);
        final type = ['Islak', 'Kirli', 'Islak & Kirli'][a.details['diaper_type'] ?? 0];
        title = '$type bez';
        subtitle = 'Bez değişimi';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E28), width: 0.5)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFFCCCCCC))),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF555555))),
            ]),
          ),
          Text(DateFormat('HH:mm').format(a.time), style: const TextStyle(fontSize: 11, color: Color(0xFF555555))),
        ],
      ),
    );
  }
}
