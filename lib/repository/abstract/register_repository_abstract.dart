import '../../domain/dtos/clean_register_dto.dart';

import '../../domain/entities/registers.dart';

abstract class RegisterRepositoryAbstract {
  Future<String> newRegister(Register register);
  Future<Register> getRegisterById(String id);
  Future<List<Register>> getAll();
  Future<List<CleanRegisterDto>> fetchCleanRegistersDto();
  Future<List<CleanRegisterDto>> fetchFinalizedCleanRegistersDto();
  Future<List<CleanRegisterDto>> fetchNonFinalizedCleanRegistersDto();
  Future<List<CleanRegisterDto>> fetchRegistersByPerson(String cpf);
  Future<List<CleanRegisterDto>> fetchCleanRegisterByCarPlate(String plate);
  Future<int> finalizeRegister(String id, String exitLocation);
  Stream<int> lengthNonFinalizedRegister();
}
