import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';

// Базовый класс для всех состояний
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

// Начальное состояние
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

// Состояние загрузки
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

// Состояние успешной загрузки
class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

// Состояние ошибки
class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
