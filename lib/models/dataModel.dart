class Data {
  int id;
  String name;
  String nominal;
  String category;
  String date;

  Data(this.id, this.name, this.nominal, this.category, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'nominal': nominal,
      'category': category,
      'date': date,
    };
    return map;
  }

  Data.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    nominal = map['nominal'];
    category = map['category'];
    date = map['date'];
  }
}