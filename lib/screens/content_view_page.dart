import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentViewPage extends StatelessWidget {
  final String category;
  final String userRole;

  const ContentViewPage({
    Key? key,
    required this.category,
    required this.userRole,
  }) : super(key: key);

  void openAdminEditorForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Admin Data Entry Form for $category"),
      ),
    );
  }

  Future<void> updateEmojiReaction(String documentId, String selectedEmoji) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('feeds').doc(documentId);

    await postRef.update({
      'reactions.$selectedEmoji': FieldValue.arrayUnion([currentUser.uid]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feeds')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar dados."));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dataDocs = snapshot.data!.docs;

          if (dataDocs.isEmpty) {
            return const Center(child: Text("Nenhum registro encontrado."));
          }

          return ListView.builder(
            itemCount: dataDocs.length,
            itemBuilder: (context, index) {
              var doc = dataDocs[index];
              var item = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(item['title'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['description'] ?? ''),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Text("🙏"),
                            onPressed: () => updateEmojiReaction(doc.id, "🙏"),
                          ),
                          IconButton(
                            icon: const Text("❤️"),
                            onPressed: () => updateEmojiReaction(doc.id, "❤️"),
                          ),
                          IconButton(
                            icon: const Text("👍"),
                            onPressed: () => updateEmojiReaction(doc.id, "👍"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
              child: const Icon(Icons.add_comment),
              onPressed: () => openAdminEditorForm(context),
            )
          : null,
    );
  }
}
