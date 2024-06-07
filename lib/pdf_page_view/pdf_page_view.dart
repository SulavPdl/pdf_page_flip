import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PDFPageView extends StatefulWidget {
  final int pageNumber;
  final String filePath;

  const PDFPageView({super.key, required this.pageNumber, required this.filePath});

  @override
  State<PDFPageView> createState() => _PDFPageViewState();
}

class _PDFPageViewState extends State<PDFPageView> {
  late PdfController _pdfController;
  bool _isReady = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePdfController();
  }

  Future<void> _initializePdfController() async {
    try {
      _pdfController = PdfController(
        document: PdfDocument.openFile(widget.filePath),
        initialPage: widget.pageNumber - 1, // PdfViewController uses 0-based indexing for pages
      );

      setState(() {
        _isReady = true;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: <Widget>[
          if (_isReady)
            PdfView(
              controller: _pdfController,
            )
          else if (_errorMessage.isNotEmpty)
            Center(child: Text(_errorMessage))
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
