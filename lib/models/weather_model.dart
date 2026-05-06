import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String city;
  final String country;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String icon;

  const WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.icon,
  });

  // fromJson - парсинг JSON в объект
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['main'] ?? 'Unknown',
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }

  // toJson - преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': city,
      'sys': {'country': country},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {
          'main': description,
          'icon': icon,
        }
      ],
      'wind': {'speed': windSpeed},
    };
  }

  @override
  List<Object?> get props => [
        city,
        country,
        temperature,
        description,
        feelsLike,
        humidity,
        windSpeed,
        pressure,
        icon,
      ];
}
