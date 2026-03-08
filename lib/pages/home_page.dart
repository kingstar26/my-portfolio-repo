import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  bool isChatOpen = false;
  bool showTyping = false;
  bool showMessage = false;
  String messageTime = '';

  final String whatsAppUrl = 'https://wa.me/254790102460?text=Hi%20Hezron!';

  /// ✅ Updated CV Link
  final String cvUrl =
      'https://drive.google.com/file/d/108GM0FhX5_FGzDWpnf9pJksNlU2PQEh7/preview';

  late final AnimationController _typingController;
  late final Animation<double> _typingAnimation;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  /// New AppBar & Bottom Bar color
  final Color barColor = const Color(0xFF1F1F2E);

  @override
  void initState() {
    super.initState();

    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _typingAnimation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_typingController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void toggleChat() {
    setState(() {
      isChatOpen = !isChatOpen;

      if (isChatOpen) {
        showTyping = true;
        showMessage = false;

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;

          setState(() {
            showTyping = false;
            showMessage = true;

            final now = DateTime.now();
            messageTime =
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
          });
        });
      }
    });
  }

  Future<void> _startWhatsAppChat() async {
    final Uri url = Uri.parse(whatsAppUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  Future<void> _downloadCV() async {
    final Uri url = Uri.parse(cvUrl);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    final drawerItems = [
      _DrawerItem(title: "Home", onTap: () => scrollToSection(_heroKey)),
      _DrawerItem(title: "About", onTap: () => scrollToSection(_aboutKey)),
      _DrawerItem(title: "Projects", onTap: () => scrollToSection(_projectsKey)),
      _DrawerItem(title: "Contact", onTap: () => scrollToSection(_contactKey)),
      _DrawerItem(title: "Download CV", onTap: _downloadCV),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: barColor,
        title: const Text(
          "{ Hezron }",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        actions: isMobile
            ? null
            : [
                TextButton(
                  onPressed: () => scrollToSection(_heroKey),
                  child: const Text("Home"),
                ),
                TextButton(
                  onPressed: () => scrollToSection(_aboutKey),
                  child: const Text("About"),
                ),
                TextButton(
                  onPressed: () => scrollToSection(_projectsKey),
                  child: const Text("Projects"),
                ),
                TextButton(
                  onPressed: () => scrollToSection(_contactKey),
                  child: const Text("Contact"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _downloadCV,
                  child: const Text("Download CV"),
                ),
                const SizedBox(width: 20),
              ],
      ),
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: barColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 16),
                    ...drawerItems.map(
                      (item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        dense: true,
                        title: Text(item.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        onTap: () {
                          Navigator.pop(context);
                          item.onTap();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      HeroSection(
                        key: _heroKey,
                        onContactPressed: () => scrollToSection(_contactKey),
                        onViewWorkPressed: () => scrollToSection(_projectsKey),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: AboutSection(
                          key: _aboutKey,
                          controller: _scrollController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ProjectsSection(
                          key: _projectsKey,
                          controller: _scrollController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ContactSection(
                          key: _contactKey,
                          controller: _scrollController,
                        ),
                      ),
                      const SizedBox(height: 20), // spacing above bottom bar
                    ],
                  ),
                ),
              ),

              // Fixed bottom bar
              Container(
                width: double.infinity,
                color: barColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '© Hezron Njenga $currentYear',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),

          /// WHATSAPP BUTTON
          Positioned(
            left: 24,
            bottom: 70, // offset above bottom bar
            child: FloatingActionButton.extended(
              onPressed: toggleChat,
              backgroundColor: const Color(0xFF25D366),
              icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
              label: const Text(
                'Lets Talk',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// CHAT BOX
          if (isChatOpen)
            Positioned(
              left: 24,
              bottom: 140, // offset above bottom bar
              child: Container(
                width: 300,
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF25D366),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hezron',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text('Online',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showTyping)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                3,
                                (index) => FadeTransition(
                                  opacity: _typingAnimation,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (showMessage)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hi there 👋\nThank you for visiting my portfolio. How can I help you?',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      messageTime,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _startWhatsAppChat,
                              icon: const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                              ),
                              label: const Text('Start Chat'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final String title;
  final VoidCallback onTap;
  _DrawerItem({required this.title, required this.onTap});
}