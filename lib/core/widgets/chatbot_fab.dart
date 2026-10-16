import 'package:flutter/material.dart';

import '../theme/batik_theme.dart';

/// Floating Action Button (FAB) di kanan bawah untuk membuka Asisten Chatbot Ngentrong.
class ChatbotFab extends StatelessWidget {
  const ChatbotFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openChatDialog(context),
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

  void _openChatDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const _ChatDialog(),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });

  final String text;
  final bool isUser;
  final String time;
}

class _ChatDialog extends StatefulWidget {
  const _ChatDialog();

  @override
  State<_ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<_ChatDialog> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Halo! Saya Asisten Batik Desa Ngentrong. Ada yang bisa saya bantu mengenai produk pengrajin UMKM, motif cengkeh, atau cara pemesanan?',
      isUser: false,
      time: 'Baru saja',
    ),
  ];

  final List<String> _quickQuestions = [
    'Apa motif batik khas Ngentrong?',
    'Daftar toko UMKM di sini?',
    'Cara pesan dari beberapa toko?',
    'Rekomendasi batik pria?',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend(String query) {
    final text = query.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(
        _ChatMessage(text: text, isUser: true, time: 'Baru saja'),
      );
    });

    _scrollToBottom();

    // Jawaban otomatis cerdas seputar Desa Ngentrong
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final reply = _generateBotReply(text);
      setState(() {
        _messages.add(
          _ChatMessage(text: reply, isUser: false, time: 'Baru saja'),
        );
      });
      _scrollToBottom();
    });
  }

  String _generateBotReply(String q) {
    final lower = q.toLowerCase();
    if (lower.contains('motif') || lower.contains('cengkeh')) {
      return 'Motif utama kebanggaan Desa Ngentrong adalah Motif Bunga Cengkeh! Trenggalek kaya akan cengkeh, dan pengrajin Ngentrong menggambarkannya dengan indah berpadu motif parang dan sekar jagad.';
    } else if (lower.contains('toko') || lower.contains('umkm') || lower.contains('daftar')) {
      return 'Di Desa Ngentrong ada beberapa UMKM binaan: Batik Barokah Ngentrong, Sanggar Sekar Jagad, Batik Melati Karangan, Omah Batik Ngentrong Asri, dan Batik Tulis Sekar Arum. Anda bisa klik bulatan toko di Beranda untuk melihat koleksinya!';
    } else if (lower.contains('pesan') || lower.contains('beli') || lower.contains('cara')) {
      return 'Anda bisa menambahkan batik dari berbagai toko ke dalam Keranjang. Di halaman Keranjang, pesanan akan otomatis dikelompokkan per UMKM asalnya sehingga transparan dan memudahkan pengiriman!';
    } else if (lower.contains('pria') || lower.contains('kemeja')) {
      return 'Untuk pria, kami sangat merekomendasikan "Kemeja Batik Cengkeh Lengan Panjang" dari Batik Barokah atau "Kemeja Kasual Batik Kerah Mandar" dari Omah Batik Ngentrong Asri!';
    } else {
      return 'Terima kasih atas pertanyaannya! Semua produk di sini dibuat langsung oleh tangan pengrajin warga Desa Ngentrong, Karangan, Trenggalek dengan bahan primissima dan pewarna berkualitas.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: Column(
          children: [
            // Header Dialog
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: const BoxDecoration(
                color: BatikColors.marun,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: Icon(Icons.smart_toy_outlined, color: BatikColors.marun, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asisten Batik Ngentrong',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Online • Siap membantu seputar UMKM',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Daftar Pesan
            Expanded(
              child: Container(
                color: BatikColors.kertas,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return Align(
                      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints: const BoxConstraints(maxWidth: 340),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: msg.isUser ? BatikColors.marun : Colors.white,
                          borderRadius: BorderRadius.circular(12).copyWith(
                            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(12),
                            bottomLeft: !msg.isUser ? Radius.zero : const Radius.circular(12),
                          ),
                          border: msg.isUser ? null : Border.all(color: BatikColors.garis),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isUser ? Colors.white : BatikColors.sogaGelap,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Pertanyaan Cepat (Quick Chips)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickQuestions.map((q) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(q, style: const TextStyle(fontSize: 11.5)),
                        backgroundColor: BatikColors.kertas,
                        side: const BorderSide(color: BatikColors.garis),
                        onPressed: () => _handleSend(q),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(height: 1, color: BatikColors.garis),

            // Input Kolom
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSend,
                      decoration: InputDecoration(
                        hintText: 'Tulis pertanyaan Anda...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        isDense: true,
                        filled: true,
                        fillColor: BatikColors.kertas,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: BatikColors.garis),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: BatikColors.garis),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: BatikColors.marun),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: BatikColors.marun,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    onPressed: () => _handleSend(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

