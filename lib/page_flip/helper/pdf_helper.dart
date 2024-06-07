import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PDFHelper {
  static Future<File> downloadPdf(String url) async {
    final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sample.pdf');
    await file.writeAsBytes(response.data);
    return file;
  }

  static Future<int> getPdfPageCount(File file) async {
    final document = await PdfDocument.openFile(file.path);
    return document.pagesCount;
  }
}
