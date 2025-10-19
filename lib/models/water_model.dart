class WaterModel {
  final String? id;
  final double amount;
  final DateTime dateTime;

  const WaterModel({
    this.id,
    required this.amount,
    required this.dateTime,
    required String unit,
  });

  // factory method to fetch data from firebase db , as we storing data in form of json object
  factory WaterModel.fromJson(Map<String, dynamic> json, String id) {
    return WaterModel(
      id: id,
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime']),
      unit: json['unit'],
    );
  }

  //method to covert watermodel to json object for storing to firebae db
  Map<String, dynamic> toJson() {
    return {'amount': amount, 'dateTime': DateTime.now()};
  }
}
