import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewsCheck extends StatefulWidget {
  const NewsCheck({super.key});

  @override
  State<NewsCheck> createState() => _NewsCheckState();
}

class _NewsCheckState extends State<NewsCheck> {
  final TextEditingController _newsController = TextEditingController();

  @override
  void dispose() {
    _newsController.dispose();
    super.dispose();
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
                    'images/news.png', // 👈 Update to match your news mascot asset path
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
              const SizedBox(height: 24),

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
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Section Heading Label: News Content
              const Row(
                children: [
                  Text(
                    "📰 เนื้อหาข่าว / โพสต์",
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
                  Text(
                    "🖼️ ภาพประกอบ (ถ้ามี)",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6. Image Upload Button Area
              GestureDetector(
                onTap: () {
                  // TODO: Implement image picking logic here (e.g., image_picker package)
                  print("Open image picker");
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xff111827).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    // Note: Use 'dotted_border' package if you want a true dashed line
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white.withValues(alpha: 0.5), size: 40),
                      const SizedBox(height: 8),
                      Text(
                        "อัปโหลดภาพจากข่าวหรือโพสต์\n(ระบบจะไปตรวจด้วย AI ภาพ)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5), 
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
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
                    // TODO: Pass both text and the selected image to your API
                  },
                  child: const Text(
                    "ตรวจสอบข่าวนี้",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
}