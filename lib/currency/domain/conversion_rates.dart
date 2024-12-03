class ConversionRate {
  String date;
  double value;

  ConversionRate({required this.date, required this.value});

  factory ConversionRate.fromJson(Map<String, dynamic> json) {
    return ConversionRate(
      date: json['date'],
      value: json['value'],
    );
  }
}
