class User {
  final int? id;
  final String namaUser;
  // final String job;
  // final int usia;

  User({
    this.id,
    required this.namaUser,
    // required this.job,
    // required this.usia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_user': namaUser,
      // 'job': job,
      // 'usia': usia,
    };
  }
}
