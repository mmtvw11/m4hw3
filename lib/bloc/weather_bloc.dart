import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService _weatherService = WeatherService();

  WeatherBloc() : super(const WeatherInitial()) {
    // Обработчик события: загрузить погоду по городу
    on<FetchWeatherByCityEvent>(_onFetchWeatherByCity);

    // Обработчик события: загрузить погоду по координатам
    on<FetchWeatherByCoordinatesEvent>(_onFetchWeatherByCoordinates);
  }

  // Логика обработки события FetchWeatherByCityEvent
  Future<void> _onFetchWeatherByCity(
    FetchWeatherByCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // Отправляем состояние загрузки
    emit(const WeatherLoading());

    try {
      // Загружаем погоду через сервис
      final weather = await _weatherService.getWeatherByCity(event.city);
      // Отправляем состояние успеха с данными
      emit(WeatherLoaded(weather));
    } catch (e) {
      // Отправляем состояние ошибки
      emit(WeatherError(e.toString()));
    }
  }

  // Логика обработки события FetchWeatherByCoordinatesEvent
  Future<void> _onFetchWeatherByCoordinates(
    FetchWeatherByCoordinatesEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      final weather = await _weatherService.getWeatherByCoordinates(
        event.latitude,
        event.longitude,
      );
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
