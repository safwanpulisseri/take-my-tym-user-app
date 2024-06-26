part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

final class CurrentLocationEvent extends LocationEvent {}

final class SearchLocationsEvent extends LocationEvent {
  final String query;
  const SearchLocationsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

final class LocationPositonEvent extends LocationEvent {

  final AutoCompletePrediction place;
  const LocationPositonEvent({ required this.place});

  @override
  List<Object> get props => [place];
}
