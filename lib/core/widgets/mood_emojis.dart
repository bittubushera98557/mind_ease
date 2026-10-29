import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MoodType {
  calm,
  happy,
  neutral,
  sad,
  worried,
}

/// MindEase 5 Mood Expressive Emojis Row
class MoodEmojisRow extends StatefulWidget {
  final ValueChanged<MoodType>? onMoodSelected;
  final MoodType? initialSelected;
  final double emojiSize;

  const MoodEmojisRow({
    Key? key,
    this.onMoodSelected,
    this.initialSelected,
    this.emojiSize = 36.0,
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
    ),
    _MoodItem(
      type: MoodType.happy,
      color: AppColors.moodHappy,
      label: 'Happy',
    ),
    _MoodItem(
      type: MoodType.neutral,
      color: AppColors.moodNeutral,
      label: 'Neutral',
    ),
    _MoodItem(
      type: MoodType.sad,
      color: AppColors.moodSad,
      label: 'Sad',
    ),
    _MoodItem(
      type: MoodType.worried,
      color: AppColors.moodWorried,
      label: 'Worried',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _moods.map((item) {
        final isSelected = _selectedMood == item.type;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Container(
                width: widget.emojiSize,
                height: widget.emojiSize,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withOpacity(isSelected ? 0.45 : 0.2),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomPaint(
                  size: Size(widget.emojiSize, widget.emojiSize),
                  painter: _MoodFacePainter(
                    mood: item.type,
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

  const _MoodItem({
    required this.type,
    required this.color,
    required this.label,
  });
}

class _MoodFacePainter extends CustomPainter {
  final MoodType mood;

  _MoodFacePainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = const Color(0xFF261D1A).withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final mouthPaint = Paint()
      ..color = const Color(0xFF261D1A).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.058
      ..strokeCap = StrokeCap.round;

    final eyeRadius = size.width * 0.055;
    final eyeY = size.height * 0.38;
    final leftEyeX = size.width * 0.33;
    final rightEyeX = size.width * 0.67;

    // Draw eyes
    canvas.drawCircle(Offset(leftEyeX, eyeY), eyeRadius, eyePaint);
    canvas.drawCircle(Offset(rightEyeX, eyeY), eyeRadius, eyePaint);

    final mouthY = size.height * 0.66;
    final mouthWidth = size.width * 0.36;
    final mouthLeft = (size.width - mouthWidth) / 2;
    final mouthRight = mouthLeft + mouthWidth;

    switch (mood) {
      case MoodType.calm:
        // Gentle slight smile
        final path = Path();
        path.moveTo(mouthLeft, mouthY);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY + (size.height * 0.1),
          mouthRight,
          mouthY,
        );
        canvas.drawPath(path, mouthPaint);
        break;

      case MoodType.happy:
        // Cheerful open smile
        final path = Path();
        path.moveTo(mouthLeft, mouthY - 1);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY + (size.height * 0.18),
          mouthRight,
          mouthY - 1,
        );
        canvas.drawPath(path, mouthPaint);
        break;

      case MoodType.neutral:
        // Straight line mouth
        canvas.drawLine(
          Offset(mouthLeft, mouthY + 2),
          Offset(mouthRight, mouthY + 2),
          mouthPaint,
        );
        break;

      case MoodType.sad:
        // Downward frown mouth
        final path = Path();
        path.moveTo(mouthLeft, mouthY + 4);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY - (size.height * 0.1),
          mouthRight,
          mouthY + 4,
        );
        canvas.drawPath(path, mouthPaint);
        break;

      case MoodType.worried:
        // Wavy / squiggly mouth
        final path = Path();
        final seg = mouthWidth / 4;
        path.moveTo(mouthLeft, mouthY + 2);
        path.quadraticBezierTo(
          mouthLeft + seg,
          mouthY - 3,
          mouthLeft + (seg * 2),
          mouthY + 2,
        );
        path.quadraticBezierTo(
          mouthLeft + (seg * 3),
          mouthY + 6,
          mouthRight,
          mouthY + 1,
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
