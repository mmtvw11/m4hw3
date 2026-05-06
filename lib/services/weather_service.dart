import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../models/city_model.dart';

class WeatherService {
  // OpenWeatherMap API
  static const String _weatherApiKey = ''; // Добавьте ваш API ключ от openweathermap.org
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // RapidAPI for city search (используем api-ninjas)
  static const String _citiesApiKey = ''; // Добавьте ваш API ключ от api-ninjas.com
  static const String _citiesBaseUrl = 'https://api.api-ninjas.com/v1';

  final Dio _dio = Dio();
  final Dio _citiesDio = Dio();

  WeatherService() {
    // Инициализация для сервиса городов
    _citiesDio.options.headers = {
      'X-Api-Key': _citiesApiKey,
    };
  }

  // Получить погоду по названию города
  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      if (_weatherApiKey.isEmpty) {
        throw Exception(
          'API ключ не установлен. Пожалуйста, добавьте ваш ключ от openweathermap.org',
        );
      }

      final response = await _dio.get(
        '$_weatherBaseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': _weatherApiKey,
          'units': 'metric', // Температура в Цельсиях
          'lang': 'ru', // Описание на русском
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Не удалось загрузить погоду');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Город не найден');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Ошибка API ключа');
      }
      throw Exception('Ошибка сети: ${e.message}');
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
      if (_weatherApiKey.isEmpty) {
        throw Exception(
          'API ключ не установлен. Пожалуйста, добавьте ваш ключ от openweathermap.org',
        );
      }

      final response = await _dio.get(
        '$_weatherBaseUrl/weather',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': _weatherApiKey,
          'units': 'metric',
          'lang': 'ru',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Не удалось загрузить погоду');
      }
    } on DioException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить список городов по названию
  Future<List<CityModel>> searchCities(String query) async {
    try {
      if (_citiesApiKey.isEmpty) {
        throw Exception(
          'API ключ не установлен. Пожалуйста, добавьте ваш ключ от api-ninjas.com',
        );
      }

      final response = await _citiesDio.get(
        '$_citiesBaseUrl/city',
        queryParameters: {
          'name': query,
          'limit': 20,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((city) => CityModel.fromJson(city as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Не удалось загрузить список городов');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Ошибка API ключа для поиска городов');
      }
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка поиска: $e');
    }
  }
}
