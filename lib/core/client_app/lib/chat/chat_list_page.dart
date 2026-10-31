import 'package:flutter/material.dart';
import 'chat_room_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // Data chat menggunakan path asset .png yang benar
  final List<Map<String, dynamic>> _chatData = [
    {
      "name": "Pemilik Kos Mahogani",
      "message": "Halo Kak! Masih ada 1 kamar....",
      "time": "10:30",
      "unread": 1,
      "avatar": "assets/foto_profile_1.png",
    },
    {
      "name": "Pemilik Kos Meranti",
      "message": "Halo Kak! Masih ada 5 kamar....",
      "time": "11:09",
      "unread": 0,
      "avatar": "assets/foto_profile_2.png",
    },
    {
      "name": "Pemilik Kos Mahonti",
      "message": "Halo Kak! Masih ada 5 kamar....",
      "time": "11:09",
      "unread": 0,
      "avatar": "assets/foto_profile_2.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          // Header Biru AyoKost
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 14,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CA0FF), Color(0xFF1E88E5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: const Text(
              'Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Search Bar & Daftar Percakapan
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                // Kolom Pencarian
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // List Percakapan
                ..._chatData.map((chat) {
                  final String name = chat['name'].toString();
                  final String message = chat['message'].toString();
                  final String time = chat['time'].toString();
                  final String avatar = chat['avatar'].toString();
                  final int unread = int.tryParse(chat['unread'].toString()) ?? 0;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      
                      // Menampilkan Foto Profil Lokal
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          avatar,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                        ),
                      ),

                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          const SizedBox(height: 6),
                          if (unread > 0)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CA0FF),
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(height: 10),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomPage(name: name),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}