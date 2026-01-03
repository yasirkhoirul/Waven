

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waven/data/auth_repository_impl.dart';
import 'package:waven/data/booking_repository_impl.dart';
import 'package:waven/data/remote/data_local_impl.dart';
import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/data/package_repository_impl.dart';
import 'package:waven/data/remote/dio.dart';
import 'package:waven/domain/repository/auth_repository.dart';
import 'package:waven/domain/repository/booking_repository.dart';
import 'package:waven/domain/repository/package_repository.dart';
import 'package:waven/domain/usecase/get_addons_all.dart';
import 'package:waven/domain/usecase/get_check_tanggal.dart';
import 'package:waven/domain/usecase/get_check_transaction.dart';
import 'package:waven/domain/usecase/get_detail_invoice.dart';
import 'package:waven/domain/usecase/get_detail_package.dart';
import 'package:waven/domain/usecase/get_list_gdrive.dart';
import 'package:waven/domain/usecase/get_list_invoice_user.dart';
import 'package:waven/domain/usecase/get_package_all.dart';
import 'package:waven/domain/usecase/get_porto_all.dart';
import 'package:waven/domain/usecase/get_profile.dart';
import 'package:waven/domain/usecase/get_token.dart';
import 'package:waven/domain/usecase/get_univdropdown.dart';
import 'package:waven/domain/usecase/post_booking.dart';
import 'package:waven/domain/usecase/post_edited_photo.dart';
import 'package:waven/domain/usecase/post_login.dart';
import 'package:waven/domain/usecase/post_logout.dart';
import 'package:waven/domain/usecase/post_signup.dart';
import 'package:waven/domain/usecase/post_transaction.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/detail_invoice_cubit.dart';
import 'package:waven/presentation/cubit/google_drive_cubit.dart';
import 'package:waven/presentation/cubit/list_invoice_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/package_detail_cubit.dart';
import 'package:waven/presentation/cubit/porto_all_cubit.dart';
import 'package:waven/presentation/cubit/profile_cubit.dart';
import 'package:waven/presentation/cubit/signup_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/cubit/transaction_cubit.dart';

final locator = GetIt.instance;


Future<void> init()async{
  //cubic
  locator.registerCachedFactory(() => AuthCubit(locator(), getToken: locator(), postLogout: locator()),);
  locator.registerCachedFactory(() => SignupCubit(locator(), getUnivdropdown: locator()),);
  locator.registerCachedFactory(() => TokenauthCubit(locator(), postLogout: locator()),);
  locator.registerCachedFactory(() => PackageAllCubit(locator()),);
  locator.registerCachedFactory(() => PortoAllCubit(locator()),);
  locator.registerCachedFactory(() => PackageDetailCubit(locator()),);
  locator.registerCachedFactory(() => ListInvoiceCubit(locator()),);
  locator.registerCachedFactory(() => ProfileCubit(locator()),);
  locator.registerCachedFactory(() => DetailInvoiceCubit(locator(),locator()),);
  locator.registerCachedFactory(() => TransactionCubit(locator(), postTransaction: locator(), getCheckTransaction: locator()),);
  locator.registerCachedFactory(() => GoogleDriveCubit(locator()),);
  locator.registerCachedFactory(() => BookingCubit(locator(), getAddonsAll: locator(), postBooking: locator(), getCheckTanggal: locator(), imagePickers: locator(), getCheckTransaction: locator()),);

  //usecase
  locator.registerLazySingleton(() => PostLogin(locator()),);
  locator.registerLazySingleton(() => PostSignup(locator()),);
  locator.registerLazySingleton(() => GetToken(locator()),);
  locator.registerLazySingleton(() => GetPackageAll(locator()),);
  locator.registerLazySingleton(() => GetPortoAll(locator()),);
  locator.registerLazySingleton(() => GetDetailPackage(locator()),);
  locator.registerLazySingleton(() => GetUnivdropdown(locator()),);
  locator.registerLazySingleton(() => GetAddonsAll(locator()),);
  locator.registerLazySingleton(() => PostBooking(locator()),);
  locator.registerLazySingleton(() => PostLogout(locator()),);
  locator.registerLazySingleton(() => GetCheckTanggal(locator()),);
  locator.registerLazySingleton(() => GetListInvoiceUser(locator()),);
  locator.registerLazySingleton(() => GetProfile(locator()),);
  locator.registerLazySingleton(() => GetDetailInvoice(locator()),);
  locator.registerLazySingleton(() => GetCheckTransaction(locator()),);
  locator.registerLazySingleton(() => PostTransaction(locator()),);
  locator.registerLazySingleton(() => PostEditedPhoto(locator()),);
  locator.registerLazySingleton(() => GetListGdrive(locator()),);

  //repositoy
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(dataRemote: locator(), dataLocal: locator()),);
  locator.registerLazySingleton<PackageRepository>(() => PackageRepositoryImpl(locator()),);
  locator.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(locator(), dataLocal: locator()),);

  //remote
  locator.registerLazySingleton<DataRemote>(() => DataRemoteImpl(locator()),);
  locator.registerLazySingleton<DataLocal>(() => DataLocalImpl(locator()),);

  //storage secure
  locator.registerLazySingleton(() => FlutterSecureStorage(),);

  //dio client 
  locator.registerLazySingleton(() => DioClient(locator(),onAuthorized: () {
    locator<TokenauthCubit>().onLogout();
  },) ,);
  
  //imgage picker
  locator.registerLazySingleton(() => ImagePicker(),);

}