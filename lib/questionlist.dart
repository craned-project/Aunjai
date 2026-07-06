import 'package:flutter/material.dart';

enum QuestionType { multipleChoice, textAnswer }

class Question {
  final int id;
  final String q;
  final QuestionType type;
  final List<Choice>? choice; // For multiple choice
  final List<String>? targetKeywords; // For text scanning
  final Set<String> relevantTags; // e.g., {'crypto', 'phishing', 'urgency'}

  Question({
    required this.id,
    required this.q,
    required this.type,
    this.choice,
    this.targetKeywords,
    required this.relevantTags,
  });
}

class Choice {
  final String text;
  final Color color;
  final int score;

  Choice({
    required this.text,
    required this.color,
    required this.score
  });
}

List<Question> getTestQuestions() {
  return [
    Question(
      id: 1,
      q: "คนที่กำลังโทรหาคุณอยู่ตอนนี้... คุณรู้จักเขาเป็นการส่วนตัวมาก่อนไหม?",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "รู้จักสนิทสนมกันดี (เพื่อน/ครอบครัว)", color: Color(0xff22c55e), score: 0),
        Choice(text: "รู้จักผ่านๆ ทางออนไลน์/ไม่เคยเจอตัวจริง", color: Color(0xffeab308), score: 15),
        Choice(text: "ไม่รู้จักเลย เป็นเบอร์แปลก หรืออ้างว่าเป็นเจ้าหน้าที่", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'identity', 'context'},
    ),
    Question(
      id: 2,
      q: "ปลายสายพยายามกดดันหรือเร่งรัดให้คุณต้องตัดสินใจทำอะไรบางอย่าง 'เดี๋ยวนี้' หรือไม่?",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "ไม่เร่งเลย คุยสบายๆ ตามปกติ", color: Color(0xff22c55e), score: 0),
        Choice(text: "ค่อนข้างเร่ง แต่ยังพอนัดเวลาคุยใหม่ได้", color: Color(0xffeab308), score: 10),
        Choice(text: "ใช่! เร่งมาก บอกว่าถ้าช้าจะถูกดำเนินคดี/โดนตัดสิทธิ์ทันที", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'urgency', 'context'},
    ),
    Question(
      id: 3,
      q: "เขามีการเอ่ยถึงเรื่อง 'เงิน' 'บัญชีธนาคาร' หรือต้องการให้โอนเงินเพื่อผลประโยชน์บางอย่างไหม?",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "ไม่มีเรื่องเงินเลย แค่มาชวนคุยเรื่องอื่น", color: Color(0xff22c55e), score: 0),
        Choice(text: "ให้แจ้งเลขบัญชี หรือข้อมูลส่วนตัวเฉยๆ ยังไม่ให้โอน", color: Color(0xffeab308), score: 15),
        Choice(text: "มี! ให้โอนเงินตรวจสอบ / ลงทุน / จ่ายค่าธรรมเนียมก่อน", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'crypto', 'urgency'},
    ),
    Question(
      id: 4,
      q: "สิ่งที่เขาพูดหรือเรื่องราวที่เขาเล่า ฟังดูสมเหตุสมผลกับสถานการณ์ปัจจุบันของคุณไหม? (เช่น อ้างว่ามีพัสดุตกค้างทั้งที่คุณไม่ได้สั่งของ)",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "สมเหตุสมผลดี เป็นเรื่องที่กำลังติดต่อค้างไว้อยู่จริง", color: Color(0xff22c55e), score: 0),
        Choice(text: "มีส่วนคล้าย แต่อดสงสัยไม่ได้ว่าเขารู้ข้อมูลนี้ได้ยังไง", color: Color(0xffeab308), score: 10),
        Choice(text: "ไม่เมคเซนส์เลย แปลกมาก ไม่ตรงกับชีวิตจริงสักอย่าง", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'context'},
    ),
    Question(
      id: 5,
      q: "พิมพ์บอกเราหน่อย: เขาบอกว่าเขาติดต่อมาจากหน่วยงานไหน หรืออ้างว่าเป็นใคร? (เช่น ตำรวจ, สรรพากร, ขนส่ง)",
      type: QuestionType.textAnswer,
      relevantTags: {'phishing', 'identity'},
      targetKeywords: ["ตำรวจ", "สภ", "สรรพากร", "ขนส่ง", "พัสดุ", "ธนาคาร", "ศาล", "ดีเอสไอ", "dsi"],
    ),
    Question(
      id: 6,
      q: "ปลายสายมีการขอให้คุณดาวน์โหลดแอปพลิเคชันอื่นเพิ่มเติมเพื่อคุยต่อ หรือตรวจสอบข้อมูลไหม? (เช่น Line, แอปควบคุมหน้าจอ)",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "ไม่มีการชวนโหลดแอปใดๆ คุยจบในสาย", color: Color(0xff22c55e), score: 0),
        Choice(text: "ให้แอดไลน์คุยต่อกับเจ้าหน้าที่คนอื่น", color: Color(0xffeab308), score: 15),
        Choice(text: "ให้โหลดแอปแปลกๆ (.apk) หรือแอปควบคุมหน้าจอมือถือ", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'phishing', 'context'},
    ),
    Question(
      id: 7,
      q: "ระหว่างที่คุยกัน เขาบอกให้คุณเก็บเรื่องนี้เป็น 'ความลับ' ห้ามบอกคนใกล้ชิดหรือคนในครอบครัวใช่ไหม?",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "ไม่ได้ห้าม สามารถเล่าให้คนอื่นฟังได้ปกติ", color: Color(0xff22c55e), score: 0),
        Choice(text: "สั่งห้ามบอกคนอื่น บอกว่าเป็นความลับราชการ/รูปคดี", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'urgency'},
    ),
    Question(
      id: 8,
      q: "มีข้อเสนอเกี่ยวกับ 'เงินรางวัล' 'สิทธิพิเศษ' หรือ 'เงินดิจิทัลฟรี' เข้ามาเกี่ยวข้องกับการคุยครั้งนี้ไหม?",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "ไม่มีการพูดถึงเงินรางวัลหรือของฟรีเลย", color: Color(0xff22c55e), score: 0),
        Choice(text: "มีรางวัลใหญ่ แต่ต้องชำระค่าภาษี/ค่าดำเนินการก่อนถึงจะถอนได้", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'crypto'},
    ),
    Question(
      id: 9,
      q: "น้ำเสียง วิธีการพูด หรือการใช้ภาษาของคนในสาย มีลักษณะอย่างไร?",
      type: QuestionType.multipleChoice,
      choice: [
        Choice(text: "พูดจาสุภาพ มืออาชีพ เหมือนเจ้าหน้าที่ธนาคาร/คอลเซ็นเตอร์จริงๆ", color: Color(0xff22c55e), score: 0),
        Choice(text: "พูดจาติดขัด ใช้น้ำเสียงดุดัน ข่มขู่ หรือพยายามยัดเยียดความผิดให้", color: Color(0xffef4444), score: 25),
      ],
      relevantTags: {'context', 'identity'},
    ),
    Question(
      id: 10,
      q: "พิมพ์บอกเราหน่อย: นอกเหนือจากข้อมูลเบื้องต้น เขาพยายามถามข้อมูลส่วนตัวอะไรของคุณไปแล้วบ้าง? (เช่น เลขบัตรประชาชน, วันเกิด, เลขบัญชี)",
      type: QuestionType.textAnswer,
      relevantTags: {'identity'},
      targetKeywords: ["บัตรประชาชน", "เลขบัตร", "วันเกิด", "ที่อยู่", "เลขบัญชี", "รหัส", "otp"],
    ),
  ];
}

