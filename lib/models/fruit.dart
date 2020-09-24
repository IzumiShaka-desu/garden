class Fruit {
  int id;
  String name;
  String isAvailable;
  Fruit({this.id, this.isAvailable, this.name});
  factory Fruit.fromJson(Map json) => Fruit(
      id: int.parse(json['id']),
      name: json['fruit_name'],
      isAvailable: json['is_available']);
  Map toJson()=>{
    'id':id,
    'fruit_name':name,
    'is_available':isAvailable
  };
}
