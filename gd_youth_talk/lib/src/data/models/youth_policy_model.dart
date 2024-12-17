import 'package:xml/xml.dart';

class YouthPolicy {
  final String polyBizSjnm; // 정책명
  final String polyItcnCn; // 정책 소개
  final String sporCn; // 지원내용
  final String rqutProcCn; //
  final String rqutUrla; // 사이트 링크 주소

  YouthPolicy({
    required this.polyBizSjnm,
    required this.polyItcnCn,
    required this.sporCn,
    required this.rqutProcCn,
    required this.rqutUrla,
  });

  factory YouthPolicy.fromXml(XmlElement xml) {
    return YouthPolicy(
      polyBizSjnm: xml.findElements('polyBizSjnm').single.text,
      polyItcnCn: xml.findElements('polyItcnCn').single.text,
      sporCn: xml.findElements('sporCn').single.text,
      rqutProcCn: xml.findElements('rqutProcCn').single.text,
      rqutUrla: xml.findElements('rqutUrla').single.text,
    );
  }
}
