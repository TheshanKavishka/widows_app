import 'package:flutter/material.dart';
import 'widow.dart';
import 'package:widows_project_new/widows/widow_database.dart';
import 'package:widows_project_new/login/login_page.dart';
import 'package:widows_project_new/widows/widow_details_page.dart';

class WidowPage extends StatefulWidget {
  const WidowPage({Key? key}) : super(key: key);

  @override
  State<WidowPage> createState() => _WidowPageState();
}

class _WidowPageState extends State<WidowPage> {
  final widowDatabase = WidowDatabase();
  final TextEditingController searchController = TextEditingController();

  List<Widow> allWidows = [];
  List<Widow> filteredWidows = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Fetch widows from the database
  void _fetchWidows() {
    widowDatabase.stream.listen((widows) {
      setState(() {
        allWidows = widows;
        filteredWidows = widows;
      });
    });
  }

  // Filter widows based on search query
  void _filterWidows(String query) {
    final filtered = allWidows.where((widow) {
      final fullNameLower = widow.full_name.toLowerCase();
      final searchLower = query.toLowerCase();
      return fullNameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredWidows = filtered;
    });
  }

  // Logout function
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWidows();
    searchController.addListener(() {
      _filterWidows(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Widows List"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search widows...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Widows List
          Expanded(
            child: filteredWidows.isEmpty
                ? const Center(
              child: Text(
                "No widows found.",
                style: TextStyle(color: Colors.white),
              ),
            )
                : ListView.builder(
              itemCount: filteredWidows.length,
              itemBuilder: (context, index) {
                final widow = filteredWidows[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.grey[900],
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      widow.full_name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      // Navigate to WidowDetailsPage with widow ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WidowDetailsPage(widowId: widow.id!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
