import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const PdfPage({super.key, required this.subjectId, required this.subjectName});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> pdfs = [];

  @override
  void initState() {
    super.initState();
    _fetchPdfs();
  }

  /// Fetch all PDFs from storage under subjectId folder
  Future<void> _fetchPdfs() async {
    final response = await supabase.storage.from('pdfs').list(path: widget.subjectId);

    setState(() {
      pdfs = response.map((file) => {
        'name': file.name,
        'file_url': supabase.storage
            .from('pdfs')
            .getPublicUrl('${widget.subjectId}/${file.name}'),
      }).toList();
    });
  }

  /// Upload a new PDF
  Future<void> _uploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final file = result.files.single;
    final filePath = '${widget.subjectId}/${file.name}';

    try {
      await supabase.storage.from('pdfs').uploadBinary(filePath, file.bytes!);

      _fetchPdfs(); // refresh list
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  /// Open the PDF in browser / device PDF viewer
  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectName)),
      body: pdfs.isEmpty
          ? const Center(child: Text("No PDFs uploaded yet"))
          : ListView.builder(
              itemCount: pdfs.length,
              itemBuilder: (_, i) {
                final pdf = pdfs[i];
                return ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(pdf['name']),
                  onTap: () => _openPdf(pdf['file_url']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadPdf,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
