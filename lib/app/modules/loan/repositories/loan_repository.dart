//? PROVIDERS

//? MODELS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class LoanRepository {
  final ApiProvider apiProvider = ApiProvider();

  LoanRepository();

  Future<ResponseApi> loanDetail(String id) async {
    return await apiProvider.genericGet("${ApiEndpoints.loan_detail}$id");
  }

  Future<ResponseApi> loanList() async {
    return await apiProvider.genericGet(ApiEndpoints.loan_active);
  }

  Future<ResponseApi> loanData(String asset) async {
    return await apiProvider.genericGet("${ApiEndpoints.loan_data}${asset}");
  }

  Future<ResponseApi> getCollateral(Map<String, dynamic> data) async {
    return await apiProvider.genericPost(ApiEndpoints.loan_collateral, data);
  }

  Future<ResponseApi> getTerms() async {
    return await apiProvider.genericGet(ApiEndpoints.loan_term);
  }

  Future<ResponseApi> setLoan(Map<String, dynamic> data) async {
    return await apiProvider.genericPost(ApiEndpoints.loan, data);
  }

  Future<ResponseApi> setLoanPayment(Map<String, dynamic> data) async {
    return await apiProvider.genericPost(ApiEndpoints.loan_payment, data);
  }
}
