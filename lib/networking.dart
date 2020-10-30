import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData() async {
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        //print(data);
        // print();
        return jsonDecode(data);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('error no internet connection');
      return null;
    }
  }
}
