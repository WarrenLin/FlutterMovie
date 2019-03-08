
class Theater {
  String name = "";
  String phone = "";
  String address = "";
  String web = "";


  Theater({this.name, this.phone, this.address, this.web});

  factory Theater.from(Map<String, dynamic> json) {
    return Theater(
        name: json['name'],
        phone: json['phone'],
        address: json['address'],
        web: json['web']
    );
  }

  @override
  String toString() {
    return 'Theater{name: $name, phone: $phone, address: $address, web: $web}';
  }
}