import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  // Fetch non-admin users from Supabase
  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('auth.Users') // Supabase auth users table
          .select('id, email')
          .neq('email', 'domewidows@gmail.com') // Exclude admin email
          .then((value) => value as List<dynamic>);

      print('Response: $response'); // Debug: Log the response

      if (response.isNotEmpty) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(response);
        });
      } else {
        print('No users found');
      }
    } catch (error) {
      print('Error fetching users: $error'); // Debug: Log the error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Delete a user from Supabase authentication
  Future<void> _deleteUser(String userId) async {
    try {
      await Supabase.instance.client.auth.admin.deleteUser(userId);

      // Refresh the user list after deletion
      await _fetchUsers();
    } catch (error) {
      print('Error deleting user: $error'); // Debug: Log the error
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user['email'] ?? 'No Email'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: Text(
                          "Are you sure you want to delete ${user['email']}?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await _deleteUser(user['id']); // Delete the user
                }
              },
            ),
          );
        },
      ),
    );
  }
}
