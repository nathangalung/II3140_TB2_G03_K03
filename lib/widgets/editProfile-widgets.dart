import 'package:flutter/material.dart';

class EditProfileWidget extends StatefulWidget {
  final String initialName; // Nama awal
  final Function(String) onSave; // Callback untuk menyimpan nama

   const EditProfileWidget({
    Key? key,
    required this.initialName,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  String _selectedAvatar = 'assets/img/avatar-profile.jpg';
  final TextEditingController _nameController = TextEditingController();

  // Dummy list of local avatars
  final List<String> _localAvatars = [
    'assets/img/avatar1.jpg',
    'assets/img/avatar2.jpg',
    'assets/img/avatar3.jpg',
    'assets/img/avatar4.jpg',
    'assets/img/avatar5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showEditProfileBottomSheet(context);
      },
      child: ListTile(
        leading: const Icon(Icons.edit, color: Colors.black),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  void _showEditProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).primaryColor, // Background sesuai tema
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Judul
              const Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Teks putih
                ),
              ),
              const SizedBox(height: 16),
              // Avatar saat ini
              GestureDetector(
                onTap: () {
                  _showAvatarSelection(context); // Buka GridView untuk memilih avatar
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_selectedAvatar),
                ),
              ),
              const SizedBox(height: 16),
              // Input TextField
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white), // Teks putih
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle:
                      const TextStyle(color: Colors.white), // Label putih
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border putih
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white), // Border fokus putih
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Tombol putih
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Simpan logika nama dan avatar
                    String newName = _nameController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.of(context).pop(); // Tutup bottom sheet
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor, // Teks warna tema
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAvatarSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Avatar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Jumlah kolom
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _localAvatars.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = _localAvatars[index]; // Set avatar baru
                      });
                      Navigator.pop(context); // Tutup modal setelah memilih
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(_localAvatars[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
