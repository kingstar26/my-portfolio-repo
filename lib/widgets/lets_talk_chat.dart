import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LetsTalkChat extends StatefulWidget {
  const LetsTalkChat({super.key});

  @override
  State<LetsTalkChat> createState() => _LetsTalkChatState();
}

class _LetsTalkChatState extends State<LetsTalkChat>
    with SingleTickerProviderStateMixin {
  bool isChatOpen = false;
  bool showTyping = false;
  bool showMessage = false;
  bool showUnread = true;

  final String whatsAppUrl = "https://wa.me/254790102460?text=Hi%20Hezron!";

  @override
  void initState() {
    super.initState();
    // Auto popup after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        isChatOpen = true;
        showTyping = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          showTyping = false;
          showMessage = true;
        });
      });
    });
  }

  void toggleChat() {
    setState(() {
      isChatOpen = !isChatOpen;
      showUnread = false;
    });
  }

  Future<void> startWhatsAppChat() async {
    final Uri url = Uri.parse(whatsAppUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      bottom: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chat window
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: isChatOpen
                ? Container(
                    key: const ValueKey(1),
                    width: 290,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(blurRadius: 20, color: Colors.black26)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF25D366),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: const [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage:
                                    NetworkImage("https://i.pravatar.cc/100"),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hezron",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Online",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        // Body
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showTyping) const TypingBubble(),
                              if (showMessage) const MessageBubble(),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: startWhatsAppChat,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.white,
                                  ),
                                  label: const Text("Start Chat"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          // Floating button
          GestureDetector(
            onTap: toggleChat,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
                  SizedBox(width: 8),
                  Text("Let's Talk", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: const [
        Dot(),
        Dot(delay: 200),
        Dot(delay: 400),
      ]),
    );
  }
}

class Dot extends StatefulWidget {
  final int delay;
  const Dot({this.delay = 0, super.key});

  @override
  State<Dot> createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      controller.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 6,
        height: 6,
        decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Hi there 👋 Thank you for visiting my portfolio. How may I help you?",
      ),
    );
  }
}