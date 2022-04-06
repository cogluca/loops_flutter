import 'package:http/http.dart';
import 'package:http/io_client.dart';



class GoogleAPIClient extends IOClient {
  Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {  Map<String, String>? headers}) {
    var uri = Uri.parse("$url");
    super.head(uri, headers: headers!..addAll(_headers));
    throw '';
  }
}