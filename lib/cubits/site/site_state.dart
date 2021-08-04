part of 'site_cubit.dart';

abstract class SiteState extends Equatable {
  const SiteState();

  @override
  List<Object> get props => [];
}

class SiteInitial extends SiteState {}

class SiteLoading extends SiteState {}

class SiteFetched extends SiteState {
  final List<Site> sites;
  const SiteFetched({@required this.sites});

  @override
  List<Object> get props => [sites];
}

class SiteFetchedError extends SiteState {
  final String errorMessage;
  const SiteFetchedError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}