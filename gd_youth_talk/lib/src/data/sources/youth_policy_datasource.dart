import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gd_youth_talk/src/data/models/youth_policy_model.dart';

class YouthPolicyDataSource {
  final String apiUrl = dotenv.env['API_URL']!;
  final String apiKey = dotenv.env['API_KEY']!;
  final String srchPolyBizSecd = '003002001025';

  Future<List<YouthPolicy>> fetchYouthPolicies({
    required int display,
    required int pageIndex,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$apiUrl?openApiVlak=$apiKey&display=$display&pageIndex=$pageIndex&srchPolyBizSecd=003002001025',
        ),
      );

      if (response.statusCode == 200) {
        String xmlData = response.body;

        // XML 데이터를 XmlDocument로 파싱
        final XmlDocument document = XmlDocument.parse(xmlData);

        // XML에서 YouthPolicy 리스트 추출
        final List<YouthPolicy> policies = [];
        final policyElements = document.findAllElements('youthPolicy'); // XML에서 YouthPolicy 태그를 찾기

        for (var policyElement in policyElements) {
          policies.add(YouthPolicy.fromXml(policyElement)); // 각 YouthPolicy 요소를 모델로 변환
        }

        return policies;
      } else {
        throw Exception('Failed to load XML data');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}