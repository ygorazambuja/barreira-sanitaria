import '../../domain/dtos/clean_register_dto.dart';

import '../../domain/entities/registers.dart';

abstract class RegisterRepositoryAbstract {
  Future<void> newRegister(Register register);
  Future<Register> getRegisterById(String id);
  Future<List<Register>> getAll();
  Future<List<CleanRegisterDto>> fetchCleanRegistersDto();

  Future<List<CleanRegisterDto>> fetchFinalizedCleanRegistersDto();
  Future<List<CleanRegisterDto>> fetchNonFinalizedCleanRegistersDto();
}
