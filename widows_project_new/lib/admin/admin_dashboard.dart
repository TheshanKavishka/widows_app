import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:widows_project_new/login/login_page.dart';
import 'user_view.dart';
import 'widow_view.dart';
import 'remark_view.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdminDashboardBody();
  }
}

class AdminDashboardBody extends StatefulWidget {
  const AdminDashboardBody({Key? key}) : super(key: key);

  @override
  State<AdminDashboardBody> createState() => _AdminDashboardBodyState();
}

class _AdminDashboardBodyState extends State<AdminDashboardBody> {
  // GlobalKey to control Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Logout Function
  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    // Navigate back to Login Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

  // Function to navigate to a specific page
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black, // Black background for the screen
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),

      // Right-side Navigation Drawer
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Text(
                  'Admin Menu',
                  style: TextStyle(color: Colors.amber, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),

      // Body Content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User Button
            _buildMainButton(
              label: "Users",
              onPressed: () => _navigateTo(context, const UserView()),
            ),
            const SizedBox(height: 20),

            // Widow Button
            _buildMainButton(
              label: "Widows",
              onPressed: () => _navigateTo(context, const WidowView()),
            ),
            const SizedBox(height: 20),

            // Remark Button
            _buildMainButton(
              label: "Remarks",
              onPressed: () => _navigateTo(context, const RemarkView()),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build main navigation buttons
  Widget _buildMainButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: 200, // Fixed size for all buttons
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber, // Amber button background
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
