import 'widow.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WidowDatabase {
  final database = Supabase.instance.client.from('widows');

  // Create
  Future createWidow(Widow newWidow) async {
    await database.insert(newWidow.toMap());
  }

  // Read: Stream for names only
  final stream = Supabase.instance.client.from('widows').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((widowMap) => Widow.justName(widowMap)).toList());

  // Read all widow data
  final allWidowsStream = Supabase.instance.client.from('widows').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((widowMap) => Widow.fromMap(widowMap)).toList());

  // Fetch a widow's details by ID
  Future<Widow?> getWidowById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('widows')
          .select()
          .eq('id', id)
          .single();

      if (response != null) {
        return Widow.fromMap(response); // Convert response to Widow object
      }
    } catch (error) {
      print('Error fetching widow by ID: $error');
    }
    return null; // Return null if no details found or error occurs
  }

  // Update
  Future updateWidow(Widow updatedWidow) async {
    if (updatedWidow.id == null) {
      throw Exception('Widow ID cannot be null for update.');
    }

    final response = await Supabase.instance.client
        .from('widows')
        .update(updatedWidow.toMap()) // Convert Widow object to Map
        .eq('id', updatedWidow.id!); // Use null-assertion operator '!' to ensure non-null

    if (response.error != null) {
      throw Exception('Failed to update widow: ${response.error!.message}');
    }
  }

  // Delete
  Future deleteNode(Widow widow) async {
    await database.delete().eq('id', widow.id!);
  }
}
