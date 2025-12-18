import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  // Fungsi untuk update status di database
  Future<void> updateStatus(String uid, String newStatus) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'approvalStatus': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    // StreamBuilder agar data selalu update realtime tanpa refresh
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'client') // Hanya ambil data client
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada pendaftar warung"));
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index].data() as Map<String, dynamic>;
            String uid = users[index].id;
            String status = user['approvalStatus'] ?? 'pending';
            String name = user['name'] ?? 'Tanpa Nama';
            String email = user['email'] ?? '-';

            // Tentukan warna status
            Color statusColor = Colors.grey;
            if (status == 'approved') statusColor = Colors.green;
            if (status == 'rejected') statusColor = Colors.red;
            if (status == 'pending') statusColor = Colors.orange;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(email),
                    Text(
                      "Status: $status",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Tampilkan tombol aksi HANYA jika status masih pending
                trailing: status == 'pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            onPressed: () => updateStatus(uid, 'approved'),
                            tooltip: "Terima",
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => updateStatus(uid, 'rejected'),
                            tooltip: "Tolak",
                          ),
                        ],
                      )
                    : null, // Jika sudah approved/rejected, tombol hilang
              ),
            );
          },
        );
      },
    );
  }
}
