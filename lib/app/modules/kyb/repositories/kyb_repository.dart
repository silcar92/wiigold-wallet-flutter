import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class KybRepository {
  final ApiProvider _api = ApiProvider();

  Future<ResponseApi> getCompanyInfo() {
    return _api.genericGet(ApiEndpoints.kyb_company_info);
  }

  Future<ResponseApi> saveCompanyInfo(Map<String, dynamic> data) {
    return _api.genericPost(ApiEndpoints.kyb_company_info, data);
  }

  Future<ResponseApi> getUboList() {
    return _api.genericGet(ApiEndpoints.kyb_ubo_list);
  }

  Future<ResponseApi> createUbo({
    required Map<String, String> fields,
    required PlatformFile idFile,
    required PlatformFile addressProof,
  }) async {
    final idBytes = await _readFileBytes(idFile);
    final addressBytes = await _readFileBytes(addressProof);

    return _api.genericPostMultipart(
      endpoint: ApiEndpoints.kyb_ubo_list,
      fields: fields,
      fileBytes: {
        'id_file': idBytes,
        'address_proof': addressBytes,
      },
      fileNames: {
        'id_file': idFile.name,
        'address_proof': addressProof.name,
      },
      contentTypes: {
        'id_file': _mimeFromExtension(idFile.extension),
        'address_proof': _mimeFromExtension(addressProof.extension),
      },
    );
  }

  Future<ResponseApi> deleteUbo(int uboId) {
    return _api.genericDelete('${ApiEndpoints.kyb_ubo_detail}$uboId/');
  }

  Future<ResponseApi> completeUbo() {
    return _api.genericPost(ApiEndpoints.kyb_ubo_complete, {});
  }

  Future<ResponseApi> getDocuments() {
    return _api.genericGet(ApiEndpoints.kyb_documents);
  }

  Future<ResponseApi> uploadDocument({
    required String docType,
    required PlatformFile file,
  }) async {
    final bytes = await _readFileBytes(file);

    return _api.genericPostMultipart(
      endpoint: ApiEndpoints.kyb_documents,
      fields: {'doc_type': docType},
      fileBytes: {'file': bytes},
      fileNames: {'file': file.name},
      contentTypes: {'file': _mimeFromExtension(file.extension)},
    );
  }

  Future<ResponseApi> deleteDocument(int docId) {
    return _api.genericDelete('${ApiEndpoints.kyb_documents_detail}$docId/');
  }

  Future<ResponseApi> submitForReview() {
    return _api.genericPost(ApiEndpoints.kyb_submit, {});
  }

  Future<ResponseApi> getStatus() {
    return _api.genericGet(ApiEndpoints.kyb_status);
  }

  Future<ResponseApi> resubmit() {
    return _api.genericPost(ApiEndpoints.kyb_resubmit, {});
  }

  Future<List<int>> _readFileBytes(PlatformFile file) async {
    if (file.bytes != null) return file.bytes!;
    if (file.path != null) return await File(file.path!).readAsBytes();
    return [];
  }

  String _mimeFromExtension(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }
}
