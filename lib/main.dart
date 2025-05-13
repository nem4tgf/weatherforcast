import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_service.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dự báo thời tiết Hà Nội',
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late Future<List<Weather>> forecast;

  @override
  void initState() {
    super.initState();
    forecast = WeatherService.fetch5DayForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                '📍 Hà Nội - 5 ngày tới',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Weather>>(
                  future: forecast,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      final weatherList = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: weatherList.length,
                        itemBuilder: (context, index) {
                          final weather = weatherList[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 6,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Image.network(weather.iconUrl),
                              title: Text(
                                weather.date.substring(0, 10),
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                '${weather.description}\n🌡 ${weather.temperature}°C - 💨 ${weather.windSpeed} m/s',
                                style: GoogleFonts.roboto(fontSize: 14),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
