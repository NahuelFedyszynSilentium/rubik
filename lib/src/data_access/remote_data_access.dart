import '../../values/k_api.dart';
import '../interfaces/i_data_access.dart';

class RemoteDataAccess implements IDataAccess {
  final baseUrl = KApiUrl;
}
