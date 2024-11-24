class User {
  final int? id;
  final String namaUser;

  User({
    this.id,
    required this.namaUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_user': namaUser,
    };
  }
}
