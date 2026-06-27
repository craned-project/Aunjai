import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart'; // Needed for kIsWeb check
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  // 🎯 ADJUSTABLE VARIABLES: Tweak these to change your bar values dynamically!
  bool _isSubmitEnabled = false;
  List<XFile> _selectedFiles = [];
  int currentTabIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff091026), // Match app background theme
      body: Stack(
        children: [
          // 🌌 Background Glows
          Positioned(
            top: 200,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff6366f1).withValues(alpha: 0.15),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Page Content Frame Window
          SafeArea(
            child: Column(
              children: [
                // Custom Navigation App Bar Header Row Layout
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff111827).withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => {context.go('/home')},
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "อุ่นใจ Image",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content View Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 200,
                            child: Image.asset(
                              'images/image.png', // Fallbacks safely to 🤖 if path structure changes
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Text(
                                      "🤖",
                                      style: TextStyle(fontSize: 80),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // File Upload Area Window Outline Dotted Frame Box
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.image, color: Colors.white, size: 28),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "อัพโหลดรูปภาพที่ต้องการให้ตรวจสอบ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "เช่น สลิป, แชท, โปรไฟล์, เอกสาร",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ImageUploadBox(
                          onImagesChanged: (files) {
                            setState(() {
                              _selectedFiles = files;
                              _isSubmitEnabled = files
                                  .isNotEmpty; // Unlocks button if 1 or more images exist
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        Opacity(
                          opacity: _isSubmitEnabled
                              ? 1.0
                              : 0.4, // Dim the button when locked
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff2563eb), // Blue
                                  Color(0xff7c3aed), // Purple
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _isSubmitEnabled
                                  ? () {
                                      // 🎯 Your submit logic goes here!
                                      print(
                                        "Uploading ${_selectedFiles.length} images...",
                                      );

                                      for (int i = 0; i < _selectedFiles.length; i++) {
                                        final file = _selectedFiles[i];
                                        String displayTitle = p.basename(file.path);

                                        print(displayTitle);
                                      }
                                    }
                                  : null, // Keeps the button natively unclickable
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "ตรวจสอบรูปภาพ", //
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff111827,
                            ).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            "- อุ่นใจไม่ได้มั่นใจ 100% นะครับ แต่เป็นเพียงการคาดเดาแนวโน้มเท่านั้น\n- หากเป็นเรื่องเงินหรือข้อมูลส่วนตัว แนะนำให้หยุดและตรวจสอบเพิ่มเติมก่อนครับ",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper path to cleanly cut out a notch for the floating shield action button
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);

    double middle = size.width / 2;
    path.lineTo(middle - 45, 0);

    // Smooth Bezier down-curves tracking standard floating system action frames layout
    path.cubicTo(middle - 30, 0, middle - 35, 32, middle, 32);
    path.cubicTo(middle + 35, 32, middle + 30, 0, middle + 45, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ImageUploadBox extends StatefulWidget {
  final ValueChanged<List<XFile>> onImagesChanged; 

  // 🎯 UPDATE CONSTRUCTOR TO REQUIRE IT
  const ImageUploadBox({super.key, required this.onImagesChanged});

  @override
  State<ImageUploadBox> createState() => _ImageUploadBoxState();
}

class _ImageUploadBoxState extends State<ImageUploadBox> {
  List<XFile> _pickedFiles = []; 
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _scrollController.dispose(); // Clean up memory when widget destroys
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (images != null && images.isNotEmpty) {
        setState(() {
          _pickedFiles = [..._pickedFiles, ...images]; // Appends new images
        });
        widget.onImagesChanged(_pickedFiles); // 🎯 Tells main page to check button
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedFiles.removeAt(index);
    });
    widget.onImagesChanged(_pickedFiles); // 🎯 Tells main page to check button
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xff111827).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _pickedFiles.isEmpty // 🎯 CHANGE THIS CHECK
            ? GestureDetector(
                onTap: _pickImages,
                behavior: HitTestBehavior.opaque,
                child: _buildPlaceholderContent(),
              )
            : _buildMultiImagePreview(),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_open_outlined,
          color: Colors.white.withValues(alpha: 0.6),
          size: 48,
        ),
        const SizedBox(height: 10),
        Text(
          "อัปโหลดภาพที่คุณคิดว่าน่าสงสัย\n(สามารถอัพโหลดได้หลายรูปภาพ)",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // 🎯 STEP 3: Build a scrollable horizontal stream preview row
  Widget _buildMultiImagePreview() {
    return Column(
      children: [
        // 1. The Scrollable Images Stream Row
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            itemCount: _pickedFiles.length + 1,
            itemBuilder: (context, index) {
              if (index == _pickedFiles.length) {
                return GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white54,
                      size: 28,
                    ),
                  ),
                );
              }

              final file = _pickedFiles[index];

              return Stack(
                children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black26,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(file.path, fit: BoxFit.cover)
                          : Image.file(File(file.path), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // 2. 🎯 Bulletproof Custom Scroll Indicator Track (Zero native asset assertions)
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
          child: AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              // 🎯 STEP 1: Safely compute the layout alignment math only if clients are attached and ready
              double alignmentX = -1.0; // Default far left position

              if (_scrollController.hasClients) {
                try {
                  final maxScroll = _scrollController.position.maxScrollExtent;
                  if (maxScroll > 0) {
                    // Map the scroll offset (0 to maxScroll) cleanly to the alignment range (-1.0 to 1.0)
                    alignmentX = (_scrollController.offset / maxScroll * 2) - 1;
                  }
                } catch (_) {
                  // Fallback guard block in case positions are momentarily unstable during layout switches
                  alignmentX = -1.0;
                }
              }

              return Container(
                width: 200, // Elegant static indicator pill length
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment(
                    alignmentX,
                    0.0,
                  ), // 🎯 STEP 2: Use the safely computed alignment variable
                  child: Container(
                    width: 20, // Moving indicator handle width
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
