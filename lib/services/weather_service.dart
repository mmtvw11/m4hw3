import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherService {
  // API ключ для OpenWeatherMap (бесплатный)
  // Регистрация: https://openweathermap.org/api
  static const String _apiKey = 'f8d18ff96e5e5f1b4b5f5e5f5f5f5f5f';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  final Dio _dio = Dio();

  // Получить погоду по названию города
  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      // GET запрос к API
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': _apiKey,
          'units': 'metric', // Температура в Цельсиях
        },
      );

      if (response.statusCode == 200) {
        // Парсинг JSON в модель
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Не удалось загрузить погоду');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить погоду по координатам
  Future<WeatherModel> getWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Не удалось загрузить погоду');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }
}
