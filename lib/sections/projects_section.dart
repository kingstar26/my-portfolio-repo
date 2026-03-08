import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  final ScrollController controller;

  const ProjectsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const projects = <_ProjectData>[
      _ProjectData(
        title: "Expense Tracker Application",
        builtWith: "", // removed Flutter · Firebase
        description:
            "Track income and expenses efficiently with a secure, real-time app using Firebase.",
        keyFeatures: ["User auth", "Add/edit/delete", "Real-time updates", "Financial summary", "Responsive UI"],
        githubUrl: "https://github.com/kingstar26/expense-tracker-app",
      ),
      _ProjectData(
        title: "Laundry Management (Chuka)",
        builtWith: "", // removed Flutter
        description:
            "Streamlined booking and order tracking for laundry services.",
        keyFeatures: ["Booking system", "Service selection", "Order tracking", "User-friendly interface"],
        githubUrl: "#", // placeholder until committed
      ),
      _ProjectData(
        title: "Food Delivery Application",
        builtWith: "", // removed Flutter · Python · HTML · CSS · JavaScript
        description:
            "Modern web app for browsing, ordering, and managing restaurant menus seamlessly.",
        keyFeatures: ["Dynamic listing", "Cart management", "Responsive UI", "Component-based architecture"],
        githubUrl: "https://github.com/kingstar26/Food-del-pro",
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Projects",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "A few things I’ve been working on recently.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final spacing = 20.0;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: projects.map((project) {
                  final width = isNarrow
                      ? double.infinity
                      : (constraints.maxWidth - spacing * 2) / 3;
                  return SizedBox(
                      width: width, child: _ProjectCard(project: project));
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String builtWith;
  final String description;
  final List<String> keyFeatures;
  final String githubUrl;

  const _ProjectData({
    required this.title,
    required this.builtWith,
    required this.description,
    required this.keyFeatures,
    required this.githubUrl,
  });
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _hovered ? 1.03 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(scale),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF020617).withOpacity(0.95),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6))
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only show builtWith if not empty
                if (widget.project.builtWith.isNotEmpty)
                  Text(
                    widget.project.builtWith.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (widget.project.builtWith.isNotEmpty)
                  const SizedBox(height: 8),
                Text(
                  widget.project.title,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.project.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.project.keyFeatures
                      .map((t) => _Tag(text: t))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ProjectButton(
                      text: "GitHub",
                      url: widget.project.githubUrl,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }
}

class _ProjectButton extends StatelessWidget {
  final String text;
  final String url;
  const _ProjectButton({required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (url == "#") return; // inactive if not committed
          final uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open link.')));
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.cyanAccent),
            color: Colors.transparent,
          ),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}