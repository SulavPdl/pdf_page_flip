import 'package:flutter/material.dart';
import 'package:pdf_page_flip/home_page/split_screen/demo_page.dart';
import 'package:pdf_page_flip/page_flip/helper/pdf_helper.dart';
import 'package:pdf_page_flip/page_flip/src/page_flip_widget.dart';
import 'package:pdf_page_flip/pdf_page_view/pdf_page_view.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  int _totalPages = 0;
  bool _isReady = false;
  String _filePath = '';

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      const url =
          'https://icseindia.org/document/sample.pdf'; // Replace with your PDF URL
      final file = await PDFHelper.downloadPdf(url);
      final pageCount = await PDFHelper.getPdfPageCount(file);

      setState(() {
        _filePath = file.path;
        _totalPages = pageCount;
        _isReady = true;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isReady
          ? PageFlipWidget(
              key: _controller,
              backgroundColor: Colors.white,
              initialIndex: 0,
              lastPage: Container(
                color: Colors.white,
                child: const Center(child: Text('Last Page!')),
              ),
              children: <Widget>[
                for (var i = 0; i < _totalPages; i++)
                //  DemoPage(page: i)
                PDFPageView(pageNumber: i + 1, filePath: _filePath),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: _isReady
          ? FloatingActionButton(
              child: const Icon(Icons.looks_5_outlined),
              onPressed: () {
                _controller.currentState?.goToPage(5);
              },
            )
          : null,
    );
  }
}
