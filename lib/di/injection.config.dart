// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:test1/bloc/home_bloc.dart' as _i494;
import 'package:test1/cubit/theme_cubit.dart' as _i321;
import 'package:test1/data/app_database.dart' as _i777;
import 'package:test1/data/testing_repository.dart' as _i946;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i777.AppDatabase>(() => _i777.AppDatabase());
    gh.lazySingleton<_i946.TestingRepository>(
      () => _i946.TestingRepository(gh<_i777.AppDatabase>()),
    );
    gh.lazySingleton<_i321.ThemeCubit>(() => _i321.ThemeCubit());
    gh.factory<_i494.HomeBloc>(
      () => _i494.HomeBloc(gh<_i946.TestingRepository>()),
    );
    return this;
  }
}
