import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MoodType {
  calm,
  happy,
  neutral,
  sad,
  worried,
}

/// MindEase 5 Mood Expressive Emojis Row with custom sizes and arch positions matching design screenshot
class MoodEmojisRow extends StatefulWidget {
  final ValueChanged<MoodType>? onMoodSelected;
  final MoodType? initialSelected;
  final double emojiSize;

  const MoodEmojisRow({
    Key? key,
    this.onMoodSelected,
    this.initialSelected,
    this.emojiSize = 58.0,
  }) : super(key: key);

  @override
  State<MoodEmojisRow> createState() => _MoodEmojisRowState();
}

class _MoodEmojisRowState extends State<MoodEmojisRow> {
  MoodType? _selectedMood;

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialSelected;
  }

  static const List<_MoodItem> _moods = [
    _MoodItem(
      type: MoodType.calm,
      color: AppColors.moodCalm,
      label: 'Calm',
      scaleMultiplier: 0.70,
      verticalOffset: 3.0,
    ),
    _MoodItem(
      type: MoodType.happy,
      color: AppColors.moodHappy,
      label: 'Happy',
      scaleMultiplier: 0.88,
      verticalOffset: -5.0,
    ),
    _MoodItem(
      type: MoodType.neutral,
      color: AppColors.moodNeutral,
      label: 'Neutral',
      scaleMultiplier: 1.08,
      verticalOffset: 0.0,
    ),
    _MoodItem(
      type: MoodType.sad,
      color: AppColors.moodSad,
      label: 'Sad',
      scaleMultiplier: 0.88,
      verticalOffset: -5.0,
    ),
    _MoodItem(
      type: MoodType.worried,
      color: AppColors.moodWorried,
      label: 'Worried',
      scaleMultiplier: 0.70,
      verticalOffset: 3.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _moods.map((item) {
        final isSelected = _selectedMood == item.type;
        final itemSize = widget.emojiSize * item.scaleMultiplier;

        return Transform.translate(
          offset: Offset(0, item.verticalOffset),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMood = item.type;
                });
                if (widget.onMoodSelected != null) {
                  widget.onMoodSelected!(item.type);
                }
              },
              child: AnimatedScale(
                scale: isSelected ? 1.10 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withOpacity(isSelected ? 0.3 : 0.08),
                        blurRadius: isSelected ? 5 : 2,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    size: Size(itemSize, itemSize),
                    painter: _MoodFacePainter(
                      mood: item.type,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MoodItem {
  final MoodType type;
  final Color color;
  final String label;
  final double scaleMultiplier;
  final double verticalOffset;

  const _MoodItem({
    required this.type,
    required this.color,
    required this.label,
    required this.scaleMultiplier,
    this.verticalOffset = 0.0,
  });
}

class _MoodFacePainter extends CustomPainter {
  final MoodType mood;

  _MoodFacePainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = const Color(0xFF32221A)
      ..style = PaintingStyle.fill;

    final mouthPaint = Paint()
      ..color = const Color(0xFF32221A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.064
      ..strokeCap = StrokeCap.round;

    final eyeRadius = size.width * 0.052;
    final eyeY = size.height * 0.38;
    final leftEyeX = size.width * 0.34;
    final rightEyeX = size.width * 0.66;

    // Draw eyes
    canvas.drawCircle(Offset(leftEyeX, eyeY), eyeRadius, eyePaint);
    canvas.drawCircle(Offset(rightEyeX, eyeY), eyeRadius, eyePaint);

    final mouthY = size.height * 0.63;
    final mouthWidth = size.width * 0.36;
    final mouthLeft = (size.width - mouthWidth) / 2;
    final mouthRight = mouthLeft + mouthWidth;

    switch (mood) {
      case MoodType.calm:
        // Gentle smile
        final path = Path();
        path.moveTo(mouthLeft, mouthY);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY + (size.height * 0.11),
          mouthRight,
          mouthY,
        );
        canvas.drawPath(path, mouthPaint);
        break;

      case MoodType.happy:
        // Cheerful smile
        final path = Path();
        path.moveTo(mouthLeft, mouthY);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY + (size.height * 0.14),
          mouthRight,
          mouthY,
        );
        canvas.drawPath(path, mouthPaint);
        break;

      case MoodType.neutral:
        // Straight horizontal line
        canvas.drawLine(
          Offset(mouthLeft, mouthY + 1),
          Offset(mouthRight, mouthY + 1),
          mouthPaint,
        );
        break;

      case MoodType.sad:
        // Downward frown mouth
        final path = Path();
        path.moveTo(mouthLeft, mouthY + (size.height * 0.08));
        path.quadraticBezierTo(
          size.width / 2,
          mouthY - (size.height * 0.04),
          mouthRight,
          mouthY + (size.height * 0.08),
        );
        canvas.drawPath(path, mouthPaint);
        break;

      case MoodType.worried:
        // Downward frown mouth
        final path = Path();
        path.moveTo(mouthLeft, mouthY + (size.height * 0.08));
        path.quadraticBezierTo(
          size.width / 2,
          mouthY - (size.height * 0.04),
          mouthRight,
          mouthY + (size.height * 0.08),
        );
        canvas.drawPath(path, mouthPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _MoodFacePainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
