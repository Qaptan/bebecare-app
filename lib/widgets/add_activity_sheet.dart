import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/baby_provider.dart';

class AddActivitySheet extends StatefulWidget {
  const AddActivitySheet({super.key});

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet> {
  int _selected = 0;
  FeedingType _feedingType = FeedingType.breast;
  BreastSide _side = BreastSide.left;
  double _amountMl = 100;
  int _durationMin = 10;
  int _sleepMin = 60;
  DiaperType _diaperType = DiaperType.wet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 36, height: 4,
                decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            const Text('Aktivite Ekle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
            const SizedBox(height: 16),
            Row(
              children: [
                _typeBtn(0, Icons.local_drink, 'Mama'),
                const SizedBox(width: 8),
                _typeBtn(1, Icons.bedtime, 'Uyku'),
                const SizedBox(width: 8),
                _typeBtn(2, Icons.baby_changing_station, 'Bez'),
              ],
            ),
            const SizedBox(height: 20),
            if (_selected == 0) _feedingForm(),
            if (_selected == 1) _sleepForm(),
            if (_selected == 2) _diaperForm(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Kaydet', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _typeBtn(int idx, IconData icon, String label) {
    final active = _selected == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selected = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1E1B4B) : const Color(0xFF16161E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? const Color(0xFF7C3AED) : const Color(0xFF2A2A35), width: 0.5),
          ),
          child: Column(children: [
            Icon(icon, color: active ? const Color(0xFFA78BFA) : const Color(0xFF555555), size: 22),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: active ? const Color(0xFFA78BFA) : const Color(0xFF555555))),
          ]),
        ),
      ),
    );
  }

  Widget _feedingForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Mama tipi', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
      const SizedBox(height: 8),
      Row(children: [
        _chip('Emzirme', _feedingType == FeedingType.breast, () => setState(() => _feedingType = FeedingType.breast)),
        const SizedBox(width: 8),
        _chip('Biberon', _feedingType == FeedingType.bottle, () => setState(() => _feedingType = FeedingType.bottle)),
      ]),
      const SizedBox(height: 14),
      if (_feedingType == FeedingType.breast) ...[
        const Text('Taraf', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
        const SizedBox(height: 8),
        Row(children: [
          _chip('Sol', _side == BreastSide.left, () => setState(() => _side = BreastSide.left)),
          const SizedBox(width: 8),
          _chip('Sağ', _side == BreastSide.right, () => setState(() => _side = BreastSide.right)),
          const SizedBox(width: 8),
          _chip('Her iki', _side == BreastSide.both, () => setState(() => _side = BreastSide.both)),
        ]),
        const SizedBox(height: 14),
        Text('Süre: $_durationMin dk', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
        Slider(
          value: _durationMin.toDouble(), min: 1, max: 60, divisions: 59,
          activeColor: const Color(0xFF7C3AED),
          onChanged: (v) => setState(() => _durationMin = v.round()),
        ),
      ] else ...[
        Text('Miktar: ${_amountMl.round()} ml', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
        Slider(
          value: _amountMl, min: 10, max: 300, divisions: 29,
          activeColor: const Color(0xFF7C3AED),
          onChanged: (v) => setState(() => _amountMl = v),
        ),
      ],
    ]);
  }

  Widget _sleepForm() {
    final h = _sleepMin ~/ 60;
    final m = _sleepMin % 60;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Uyku süresi: ${h > 0 ? "$h sa " : ""}$m dk',
          style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
      Slider(
        value: _sleepMin.toDouble(), min: 5, max: 480, divisions: 95,
        activeColor: const Color(0xFF7C3AED),
        onChanged: (v) => setState(() => _sleepMin = v.round()),
      ),
    ]);
  }

  Widget _diaperForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Bez tipi', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
      const SizedBox(height: 8),
      Row(children: [
        _chip('Islak', _diaperType == DiaperType.wet, () => setState(() => _diaperType = DiaperType.wet)),
        const SizedBox(width: 8),
        _chip('Kirli', _diaperType == DiaperType.dirty, () => setState(() => _diaperType = DiaperType.dirty)),
        const SizedBox(width: 8),
        _chip('Her ikisi', _diaperType == DiaperType.both, () => setState(() => _diaperType = DiaperType.both)),
      ]),
    ]);
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E1B4B) : const Color(0xFF16161E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? const Color(0xFF7C3AED) : const Color(0xFF2A2A35), width: 0.5),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, color: active ? const Color(0xFFA78BFA) : const Color(0xFF666666))),
      ),
    );
  }

  Future<void> _save() async {
    final baby = context.read<BabyProvider>();
    switch (_selected) {
      case 0:
        await baby.addFeeding(
          feedingType: _feedingType,
          amountMl: _feedingType == FeedingType.bottle ? _amountMl : null,
          side: _feedingType == FeedingType.breast ? _side : null,
          durationMin: _feedingType == FeedingType.breast ? _durationMin : null,
        );
        break;
      case 1:
        await baby.addSleep(durationMin: _sleepMin);
        break;
      case 2:
        await baby.addDiaper(diaperType: _diaperType);
        break;
    }
    if (mounted) Navigator.pop(context);
  }
}
