import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onContactPressed;
  final VoidCallback? onViewWorkPressed;
  final Widget? child;

  const HeroSection({
    super.key,
    this.onContactPressed,
    this.onViewWorkPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 500, maxHeight: 720),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          final textContent = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Hi, I'm Hezron 👋",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: isMobile ? 32 : 48),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Flutter Developer'),
                      TypewriterAnimatedText('Frontend Developer'),
                      TypewriterAnimatedText('Computer Science Student'),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "I build smooth, modern experiences for mobile and web, "
                "with a focus on clean UI and great performance.",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.4),
              ),
              SizedBox(height: isMobile ? 24 : 32),
              Row(
                mainAxisAlignment: isMobile
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HeroButton(
                    text: "View My Work",
                    onTap: onViewWorkPressed ?? () {},
                    isPrimary: true,
                  ),
                  SizedBox(width: isMobile ? 12 : 16),
                  _HeroButton(
                    text: "Contact Me",
                    onTap: onContactPressed ?? () {},
                  ),
                ],
              ),
              if (child != null) ...[
                SizedBox(height: isMobile ? 20 : 24),
                child!,
              ],
            ],
          );

          final imageContent = StaticProfileImage(
            size: isMobile ? 180 : 240,
          );

          if (isMobile) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageContent,
                const SizedBox(height: 24),
                textContent,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 3, child: textContent),
              const SizedBox(width: 30),
              Expanded(flex: 2, child: imageContent),
            ],
          );
        },
      ),
    );
  }
}

class _HeroButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const _HeroButton({
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isPrimary ? Colors.cyanAccent : Colors.transparent;
    final borderColor =
        widget.isPrimary ? Colors.transparent : Colors.cyanAccent;
    final transform =
        _hovered ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            side: BorderSide(color: borderColor),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          onPressed: widget.onTap,
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isPrimary ? Colors.black : Colors.cyanAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class StaticProfileImage extends StatelessWidget {
  final double size;
  const StaticProfileImage({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                startAngle: 0,
                endAngle: 6.2832,
                colors: [
                  Colors.cyanAccent,
                  Colors.purpleAccent,
                  Colors.blueAccent,
                  Colors.greenAccent,
                  Colors.cyanAccent,
                ],
              ),
            ),
          ),
          Container(
            width: size - 6,
            height: size - 6,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          ClipOval(
            child: Image.asset(
              'assets/images/profile.jpg',
              width: size - 12,
              height: size - 12,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}