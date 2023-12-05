class Ruangan {
  int id;
  String nama_ruangan, keterangan;
  int kapasitas;

  Ruangan(
      {required this.id,
      required this.nama_ruangan,
      required this.keterangan,
      required this.kapasitas});

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'],
      nama_ruangan: json['nama_ruangan'],
      keterangan: json['keterangan'],
      kapasitas: json['kapasitas'],
    );
  }
}
