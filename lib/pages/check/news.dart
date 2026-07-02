import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class NewsCheck extends StatefulWidget {
  const NewsCheck({super.key});

  @override
  State<NewsCheck> createState() => _NewsCheckState();
}

class _NewsCheckState extends State<NewsCheck> {
  final TextEditingController _newsController = TextEditingController();
  
  // Image Upload State Variables
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedFiles = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _newsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- Image Upload Methods ---
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (images.isNotEmpty) {
        setState(() {
          _pickedFiles = [..._pickedFiles, ...images]; // Appends new images
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Syncs with your outer shell background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff111827).withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
        ),
        title: const Text(
          "อุ่นใจ news",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Closes keyboard on background tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Center Mascot Image Area
              Center(
                child: SizedBox(
                  height: 180,
                  child: Image.asset(
                    'images/news.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text("🤖\n[Mascot Image]", 
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 16)
                        ),
                      );
                    },
                  ),
                ),
              ),
              // 2. Top Info Sub-Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111c30).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Text(
                  "คัดลอกข่าว หรือโพสต์ที่คุณสงสัยมาได้เลยครับ\nอุ่นใจจะช่วยตรวจสอบจากหลายแหล่ง\nและอธิบายให้เข้าใจง่ายที่สุด 😉",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Section Heading Label: News Content
              const Row(
                children: [
                  Icon(
                    Icons.newspaper,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    " เนื้อหาข่าว / โพสต์",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Large Dark Input Text Area
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111827).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _newsController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'วางข้อความข่าวที่ต้องการตรวจสอบที่นี่...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25), 
                      fontSize: 16,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Section Heading Label: Image Upload
              const Row(
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    " ภาพประกอบ (ถ้ามี)",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6. Image Upload Area (Updated)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xff111827).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _pickedFiles.isEmpty
                      ? GestureDetector(
                          onTap: _pickImages,
                          behavior: HitTestBehavior.opaque,
                          child: _buildPlaceholderContent(),
                        )
                      : _buildMultiImagePreview(),
                ),
              ),
              const SizedBox(height: 48),

              // 7. Main Action Dynamic Gradient Button
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xff2563eb), Color(0xff7c3aed)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff7c3aed).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    final String newsContent = _newsController.text.trim();
                    print("Sending News for verification: $newsContent");
                    print("Total Images Attached: ${_pickedFiles.length}");
                  },
                  child: const Text(
                    "ตรวจสอบข่าวนี้",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Clears room above bottom tab system
            ],
          ),
        ),
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

        // 2. Custom Scroll Indicator Track
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
          child: AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double alignmentX = -1.0; 

              if (_scrollController.hasClients) {
                try {
                  final maxScroll = _scrollController.position.maxScrollExtent;
                  if (maxScroll > 0) {
                    alignmentX = (_scrollController.offset / maxScroll * 2) - 1;
                  }
                } catch (_) {
                  alignmentX = -1.0;
                }
              }

              return Container(
                width: 200, 
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment(
                    alignmentX,
                    0.0,
                  ), 
                  child: Container(
                    width: 20,
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