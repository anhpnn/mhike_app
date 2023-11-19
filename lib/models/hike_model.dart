class Hike {
  String name;
  String location;
  DateTime date;//
  String partner;
  bool parkingAvailable;//
  double? length;//
  String difficulty;
  String description;
  String image;

  Hike({
    required this.name,
    required this.location,
    required this.date,
    required this.partner,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
    this.description = "",
    this.image = "",
   
  });

  
  factory Hike.fromMap(Map<String, dynamic> map) {
    return Hike(
      name: map['name'],
      location: map['location'],
      date: DateTime.parse(map['date']),
      partner: map['partner'],
      parkingAvailable: map['parkingAvailable'] == 1,
      length: map['length'],
      difficulty: map['difficulty'],
      description: map['description'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'date': date.toIso8601String(),
      'partner': partner,
      'parkingAvailable': parkingAvailable ? 1 : 0,
      'length': length,
      'difficulty': difficulty,
      'description': description,
      'image': image,
    };
  }
}
