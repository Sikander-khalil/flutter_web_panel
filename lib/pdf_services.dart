
import 'dart:ui';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:pakistan_solar_market/user_post_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  Future<void> printCustomersPdf(List<UserPost> data) async {
    // Create a new PDF document
    PdfDocument document = PdfDocument();
    PdfGrid grid = PdfGrid();

    _addHeader(grid);
    _addRows(grid, data);

    // Draw the grid
    grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    try {
      List<int> bytes = await document.save();

      // Download document
      _downloadPdf(bytes, 'report.pdf');
    } catch (e) {
      print('Error saving PDF: $e');
    } finally {
      // Dispose the document
      document.dispose();
    }
  }

  void _addHeader(PdfGrid grid) {
    grid.columns.add(count: 10);

    // Add header to the grid
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Name';
    header.cells[1].value = 'Price';
    header.cells[2].value = 'Available';
    header.cells[3].value = 'Number';
    header.cells[4].value = 'Phone No';
    header.cells[5].value = 'Posted At';
    header.cells[6].value = 'Size';
    header.cells[7].value = 'Sold';
    header.cells[8].value = 'Sub Categories';
    header.cells[9].value = 'Type';

    // Add header style
    header.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );
  }

  void _addRows(PdfGrid grid, List<UserPost> data) {
    for (final post in data) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = post.name;
      row.cells[1].value = post.price;
      row.cells[2].value = post.available;
      row.cells[3].value = post.number;
      row.cells[4].value = post.phoneno;
      row.cells[5].value = post.postedAt;
      row.cells[6].value = post.size;
      row.cells[7].value = post.sold ? 'true' : 'false'; // Convert boolean to string
      row.cells[8].value = post.subCategories;
      row.cells[9].value = post.type;
    }

    // Add rows style
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );
  }


  void _downloadPdf(List<int> bytes, String fileName) {
    // Note: You might want to use a conditional check for web/non-web environments
    // For example, using the 'universal_html' package.
    // Here, we assume it's a web environment.

    // Download document
    final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
