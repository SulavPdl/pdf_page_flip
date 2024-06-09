import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PDFPageView extends StatefulWidget {
  final String filePath;
  final int pageNumber;

  const PDFPageView({super.key, required this.filePath, required this.pageNumber});

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
        initialPage: widget.pageNumber, // Display the first page (0-based index)
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
              physics: const NeverScrollableScrollPhysics(),
              controller: _pdfController,
              onPageChanged: (page) {
                // Ensure it stays on the first page
                if (page != 0) {
                  _pdfController.jumpToPage(0);
                }
              },
              pageSnapping: false,
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
