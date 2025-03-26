import 'package:dartz/dartz.dart';
import 'package:hungrx_app/core/errors/exceptions.dart';
import 'package:hungrx_app/core/errors/failures.dart';
import 'package:hungrx_app/data/Models/profile_screen/referral_model.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/referral_datasource.dart';


class ReferralRepository {
  final ReferralDataSource dataSource;

  ReferralRepository({required this.dataSource});

  Future<Either<Failure, ReferralModel>> generateReferralCode(String userId) async {
    try {
      final result = await dataSource.generateReferralCode(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}