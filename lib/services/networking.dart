import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  String? url;
  NetworkHelper(this.url);

  Future getData() async {
    Uri uri = Uri.parse(url as String);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      String data = response.body; 
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
