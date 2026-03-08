import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AboutSection extends StatelessWidget {
  final ScrollController controller;

  const AboutSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final position = controller.hasClients ? controller.offset : 0;
        final screenHeight = MediaQuery.of(context).size.height;
        final progress = (position / screenHeight).clamp(0.0, 1.0);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Transform.translate(
                offset: Offset(0, 40 * (1 - progress)),
                child: Opacity(
                  opacity: 0.9 + 0.1 * progress,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "About Me",
            style: TextStyle(
              fontSize: 32,
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    "Hello, it’s Hezron again! Need to know me? Worry less!",
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "I am a web and app developer specializing in Flutter, HTML, CSS, JavaScript, and Python. "
            "I build responsive, efficient, and visually appealing applications that provide great user experiences. "
            "I collaborate with designers and backend developers to create high-quality applications across platforms. "
            "Currently, I am a Computer Science student at Masinde Muliro University, continuously refining my skills to deliver real solutions.",
            style: TextStyle(
              height: 1.5,
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;

              const items = [
                _AboutTag(
                  title: "Flutter",
                  description: "Building cross-platform apps with a focus on performance.",
                ),
                _AboutTag(
                  title: "HTML & CSS",
                  description: "Crafting responsive and pixel-perfect web interfaces.",
                ),
                _AboutTag(
                  title: "JavaScript",
                  description: "Adding interactivity and dynamic functionality to web apps.",
                ),
                _AboutTag(
                  title: "Python",
                  description: "Backend development, automation, and algorithm design.",
                ),
                _AboutTag(
                  title: "Problem Solving",
                  description: "Debugging and optimizing challenging flows efficiently.",
                ),
              ];

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: items.map((card) {
                  if (isNarrow) {
                    return SizedBox(width: double.infinity, child: card);
                  }
                  return SizedBox(
                    width: (constraints.maxWidth - 40) / 3,
                    child: card,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AboutTag extends StatefulWidget {
  final String title;
  final String description;

  const _AboutTag({required this.title, required this.description});

  @override
  State<_AboutTag> createState() => _AboutTagState();
}

class _AboutTagState extends State<_AboutTag> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..scale(_hovered ? 1.05 : 1.0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color.fromARGB(243, 2, 6, 23),
            border: Border.all(
              color: _hovered
                  ? Colors.cyanAccent
                  : const Color.fromARGB(20, 255, 255, 255),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withAlpha(64),
                      blurRadius: 20,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}