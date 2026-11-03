import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/batik_theme.dart';

class ChatbotFab extends StatelessWidget {
  const ChatbotFab({super.key});

  static final Uri _chatbotUrl = Uri.parse('http://localhost:65217');

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openChatbot(context),
      backgroundColor: BatikColors.marun,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.support_agent_rounded, size: 24),
      label: const Text(
        'Tanya Asisten',
        style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
    );
  }

  Future<void> _openChatbot(BuildContext context) async {
    final ok = await launchUrl(
      _chatbotUrl,
      webOnlyWindowName: '_blank', // buka tab baru
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak bisa membuka chatbot. Pastikan berjalan di http://localhost:65217',
          ),
        ),
      );
    }
  }
}