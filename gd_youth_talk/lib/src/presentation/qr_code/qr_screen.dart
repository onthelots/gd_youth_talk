import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String documentId;

  const QRCodeScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // 화면 탭하면 닫기
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.7), // 반투명 배경
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '출석 QR 코드',
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 16),

                QrImageView(
                  data: documentId,
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showQRCodeModal(BuildContext context, String documentId) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 배경 클릭 시 닫힘
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return QRCodeScreen(documentId: documentId);
      },
    );
  }
}
