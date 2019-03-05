
class Scan {
  int id;
  String key;
  String classKey;
  String admin;
  String arrive;
  String leave;
  Scan({
    this.id,
    this.key,
    this.classKey,
    this.admin,
    this.arrive,
    this.leave
  });

  factory Scan.fromMap(Map<String, dynamic> json) => Scan(
        id: json["id"],
        key: json["key"],
        classKey: json["classKey"],
        admin: json["admin"],
        arrive: json["arrive"],
        leave: json["leave"]
      );
}