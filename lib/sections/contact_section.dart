import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final ScrollController controller;
  const ContactSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const email = 'njengahezron26@gmail.com';
    const whatsappE164 = '254790102460';
    const githubUrl = 'https://github.com/kingstar26';
    const facebookUrl = 'https://www.facebook.com/search/top?q=hezron%20njenga';
    const whatsappMessage =
        "Hello Hezron 👋\nThank you for sharing your portfolio. I would like to connect with you. How may we proceed?";
    final emailUri =
        Uri(scheme: 'mailto', path: email, queryParameters: const {'subject': 'Portfolio Inquiry'});
    final whatsappUri = Uri.parse('https://wa.me/$whatsappE164?text=$whatsappMessage');
    final githubUri = Uri.parse(githubUrl);
    final facebookUri = Uri.parse(facebookUrl);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final position = controller.hasClients ? controller.offset : 0;
        final media = MediaQuery.of(context);
        final screenHeight = media.size.height;
        final isMobile = media.size.width < 800;

        // Make the scroll animation a bit more dramatic on smaller screens.
        final rawProgress = position / screenHeight;
        final progress = rawProgress.clamp(0.0, 1.0);
        final maxOffset = isMobile ? 70.0 : 40.0;
        final baseOpacity = isMobile ? 0.7 : 0.9;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Transform.translate(
                offset: Offset(0, maxOffset * (1 - progress)),
                child: Opacity(
                  opacity: baseOpacity + (1 - baseOpacity) * progress,
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
            "Contact",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Have an idea, a project, or just want to say hi? Feel free to reach out and I’ll get back to you as soon as I can.",
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final cardWidth = isNarrow ? double.infinity : (constraints.maxWidth - 20) / 2;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _ContactActionCard(
                      icon: FontAwesomeIcons.envelope,
                      title: 'Email',
                      value: email,
                      subtitle: 'Open your email client',
                      onTap: () => _openUri(context, emailUri),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ContactActionCard(
                      icon: FontAwesomeIcons.whatsapp,
                      title: 'WhatsApp',
                      value: '0790102460',
                      subtitle: 'Chat with a pre-filled message',
                      onTap: () => _openUri(context, whatsappUri),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ContactActionCard(
                      icon: FontAwesomeIcons.facebook,
                      title: 'Facebook',
                      value: 'Hezron Njenga',
                      subtitle: 'Open Facebook profile',
                      onTap: () => _openUri(context, facebookUri),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _ContactActionCard(
                      icon: FontAwesomeIcons.github,
                      title: 'GitHub',
                      value: '@kingstar26',
                      subtitle: 'View repositories',
                      onTap: () => _openUri(context, githubUri),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openUri(BuildContext context, Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link.')),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link.')),
      );
    }
  }
}

class _ContactActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;
  const _ContactActionCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ContactActionCard> createState() => _ContactActionCardState();
}

class _ContactActionCardState extends State<_ContactActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _hovered = true),
        onTapUp: (_) => setState(() => _hovered = false),
        onTapCancel: () => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..scale(_hovered ? 1.04 : 1.0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF020617).withOpacity(0.95),
            border: Border.all(
              color: _hovered ? Colors.cyanAccent : Colors.white.withOpacity(0.08),
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Center(
                  child: FaIcon(widget.icon, color: Colors.cyanAccent, size: 18),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                            color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    SelectableText(widget.value,
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(widget.subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.open_in_new, size: 18, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}