import 'package:flutter/material.dart';
import 'widow_database.dart'; // Import WidowDatabase
import 'widow.dart';

class WidowDetailsPage extends StatefulWidget {
  final int widowId; // Pass widow ID to fetch details

  const WidowDetailsPage({Key? key, required this.widowId}) : super(key: key);

  @override
  State<WidowDetailsPage> createState() => _WidowDetailsPageState();
}

class _WidowDetailsPageState extends State<WidowDetailsPage> {
  final WidowDatabase widowDatabase = WidowDatabase();
  late Future<Widow?> widowDetails;

  // Fetch widow details using WidowDatabase
  Future<Widow?> _fetchWidowDetails() async {
    return await widowDatabase.getWidowById(widget.widowId);
  }

  @override
  void initState() {
    super.initState();
    widowDetails = _fetchWidowDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Widow Details"),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Widow?>(
        future: widowDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Failed to load widow details.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final widow = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  widow.full_name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Date of Birth: ${widow.dob != null ? widow.dob!.toLocal() : 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Address: ${widow.address ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Contact: ${widow.contact_number ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "NIC: ${widow.nic ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Occupation: ${widow.occupation ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Children: ${widow.no_of_children ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Area: ${widow.area ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Time Period: ${widow.time_period ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Status: ${widow.status ?? 'Not Available'}",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
