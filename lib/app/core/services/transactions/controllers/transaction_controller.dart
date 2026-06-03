//? GetX
import 'package:get/get.dart';

//? REPOSITORIES

//? MIXINS
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/core/services/transactions/repositories/transaction_repository.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';

class TransactionController extends GetxController with LoadingMixin {
  final TransactionRepository _transactionRepository = TransactionRepository();

  RxString hauvAvailableBalance = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  getTransactionDetail(String id) async {
    try {
      final ResponseApi res = await _transactionRepository.getTransactionDetail(
        id,
      );

      if (res.status == 'error') {
        return;
      }

      if (res.data == null || res.data is! Map<String, dynamic>) {
        return;
      }

      return res;
    } catch (e) {
      print("MyLog $e");
    }
  }
}
