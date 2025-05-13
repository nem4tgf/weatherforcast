import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  final String date;
  final double temperature;
  final String description;
  final double windSpeed;
  final String iconCode;

  Weather({
    required this.date,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.iconCode,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}

class WeatherService {
  static const String apiKey = '6c6d5687b53b2662bb20dfdb2c54ab23'; // Thay bằng API của bạn
  static const String city = 'Hanoi';
  static const String apiUrl =
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey';

  static Future<List<Weather>> fetch5DayForecast() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List forecasts = data['list'];

      final dailyForecasts = forecasts.where((item) {
        final dateTime = item['dt_txt'];
        return dateTime.endsWith('12:00:00');
      }).toList();

      return dailyForecasts.map((item) {
        return Weather(
          date: item['dt_txt'],
          temperature: item['main']['temp'],
          description: item['weather'][0]['description'],
          windSpeed: item['wind']['speed'].toDouble(),
          iconCode: item['weather'][0]['icon'],
        );
      }).toList();
    } else {
      throw Exception('Lỗi khi tải dữ liệu thời tiết');
    }
  }
}
