class AttendanceStatsModel {
  int? totalAbsen;
  int? totalMasuk;
  int? totalIzin;
  bool? sudahAbsenHariIni;

  AttendanceStatsModel({
    this.totalAbsen,
    this.totalMasuk,
    this.totalIzin,
    this.sudahAbsenHariIni,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) => AttendanceStatsModel(
    totalAbsen: json["total_absen"],
    totalMasuk: json["total_masuk"],
    totalIzin: json["total_izin"],
    sudahAbsenHariIni: json["sudah_absen_hari_ini"],
  );

  Map<String, dynamic> toJson() => {
    "total_absen": totalAbsen,
    "total_masuk": totalMasuk,
    "total_izin": totalIzin,
    "sudah_absen_hari_ini": sudahAbsenHariIni,
  };
}
