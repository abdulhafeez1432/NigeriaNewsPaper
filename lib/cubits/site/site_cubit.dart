import 'package:NewsApp/models/site.dart';
import 'package:NewsApp/networking/api_exceptions.dart';
import 'package:NewsApp/repositories/site.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'site_state.dart';

class SiteCubit extends Cubit<SiteState> {
  final SiteRepository siteRepository;

  List<Site> sites;

  SiteCubit({@required this.siteRepository}) : super(SiteInitial());

  Future<void> getSites() async {
    emit(SiteLoading());
    try {
      sites = await siteRepository.getSites();
      emit(SiteFetched(sites: sites));
    } on AppException catch (e) {
      emit(SiteFetchedError(errorMessage: e.message));
    }
  }
}
