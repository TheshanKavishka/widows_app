import 'package:flutter/material.dart';
import 'package:widows_project_new/widows/widow.dart';
import 'package:widows_project_new/widows/widow_database.dart';

class WidowView extends StatefulWidget {
  const WidowView({Key? key}) : super(key: key);

  @override
  State<WidowView> createState() => _WidowPageState();
}

class _WidowPageState extends State<WidowView> {
  // Database instance
  final widowDatabase = WidowDatabase();

  // Text controller for widow name input
  final nameController = TextEditingController();

  // Add a new widow
  void addNewWidow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Widow"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter full name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final newWidow = Widow(full_name: nameController.text);

              await widowDatabase.createWidow(newWidow);

              Navigator.pop(context);
              nameController.clear();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Update an existing widow
  void updateWidow(Widow widow) {
    nameController.text = widow.full_name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Widow"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter full name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              widow.full_name = nameController.text;

              await widowDatabase.updateWidow(widow);

              Navigator.pop(context);
              nameController.clear();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Delete a widow
  void deleteWidow(Widow widow) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Widow"),
        content: const Text("Are you sure you want to delete this widow?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await widowDatabase.deleteNode(widow);

              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Widows List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWidow,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Widow>>(
        stream: widowDatabase.stream, // Stream for real-time updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No widows found."));
          }

          final widows = snapshot.data!;

          return ListView.builder(
            itemCount: widows.length,
            itemBuilder: (context, index) {
              final widow = widows[index];

              return ListTile(
                title: Text(widow.full_name),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => updateWidow(widow),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteWidow(widow),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
