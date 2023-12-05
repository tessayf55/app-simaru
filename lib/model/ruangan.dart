class Ruangan {
  int id;
  String nama_ruangan, keterangan, created_at, updated_at;
  int kapasitas;

  Ruangan(
      {required this.id,
      required this.nama_ruangan,
      required this.keterangan,
      required this.kapasitas,
      required this.created_at,
      required this.updated_at});

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'],
      nama_ruangan: json['nama_ruangan'],
      keterangan: json['keterangan'],
      kapasitas: json['kapasitas'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}
