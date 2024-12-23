class Widow {
  int? id;
  String full_name;
  DateTime? dob;
  int? age;
  String? address;
  String? area;
  String? contact_number;
  String? nic;
  String? occupation;
  int? no_of_children;
  String? pcl_name;
  String? time_period;
  String? status;

  // Constructor for full details
  Widow({
    this.id,
    required this.full_name,
    this.dob,
    this.age,
    this.address,
    this.area,
    this.contact_number,
    this.nic,
    this.occupation,
    this.no_of_children,
    this.pcl_name,
    this.time_period,
    this.status,
  });

  // Factory constructor: Only ID and Name
  factory Widow.justName(Map<String, dynamic> map) {
    return Widow(
      id: map['id'] as int?,
      full_name: map['full_name'] as String,
    );
  }

  // Factory constructor: Full details
  factory Widow.fromMap(Map<String, dynamic> map) {
    return Widow(
      id: map['id'] as int?,
      full_name: map['full_name'] as String,
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      age: map['age'] as int?,
      address: map['address'] as String?,
      area: map['area'] as String?,
      contact_number: map['contact_number'] as String?,
      nic: map['nic'] as String?,
      occupation: map['occupation'] as String?,
      no_of_children: map['no_of_children'] as int?,
      pcl_name: map['pcl_name'] as String?,
      time_period: map['time_period'] as String?,
      status: map['status'] as String?,
    );
  }

  // Convert Widow to Map for Supabase storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': full_name,
      'dob': dob?.toIso8601String(),
      'age': age,
      'address': address,
      'area': area,
      'contact_number': contact_number,
      'nic': nic,
      'occupation': occupation,
      'no_of_children': no_of_children,
      'pcl_name': pcl_name,
      'time_period': time_period,
      'status': status,
    };
  }
}
