class YogaPose {
  final String cname;
  final String name;
  final String description;
  final String imageName;
  final String rating;

  YogaPose({
    required this.cname,
    required this.name,
    required this.description,
    required this.imageName,
    required this.rating,
  });
}
final List<YogaPose> yogaPoses = [
  YogaPose(
    cname: "三角式",
    name: 'Trikonasana',
    description:
    '三角式（Trikonasana）是瑜珈中的一個姿勢，有助於伸展和強化腿部、髖部和脊柱，提高平衡感和身體的靈活性。練習時雙腳分開，身體向一側傾斜，一手指向地面，一手指向天空，保持脊柱延伸和穩定。',
    imageName: '三角式',
    rating: '2 / 5',
  ),
  YogaPose(
    cname: "樹式",
    name: 'Vrksasana',
    description:
    '樹式（Vrksasana）是一種瑜伽平衡姿勢，有助於強化腿部和核心肌群，提高平衡感和專注力。站立時，將一隻腳放在另一腿內側，雙手合十於胸前或舉過頭頂，保持深長呼吸。',
    imageName: '樹式',
    rating: '3 / 5',
  ),
  YogaPose(
    cname: "戰神三式",
    name: 'Virabhadrasana III',
    description:
    '戰神三式（Virabhadrasana III）是一種平衡姿勢，有助於強化腿部、核心和背部肌群，提升平衡感和穩定性。從戰士一式開始，身體前傾，後腿抬起與地面平行，雙手向前伸展，保持穩定呼吸。',
    imageName: '戰神三式',
    rating: "4 / 5",
  ),
  YogaPose(
    cname: "駱駝式",
    name: 'Ustrasana',
    description:
    '駱駝式（Ustrasana）是一種後彎姿勢，有助於打開胸部、伸展腹部和大腿前側，增強脊柱的靈活性。跪立時，雙手放在腳跟上，拱起背部，頭部輕輕後仰，保持深長呼吸。',
    imageName: '駱駝式',
    rating: '3 / 5',
  ),
  YogaPose(
    cname: "船式",
    name: 'Navasana',
    description:
    '船式（Navasana）是一種核心訓練姿勢，有助於強化腹肌和髖部肌群，提升平衡感和耐力。坐姿開始，雙腿抬起與地面成V字形，雙手平行前伸或握住小腿，保持背部挺直，穩定呼吸。',
    imageName: '船式',
    rating: '3 / 5',
  ),
  YogaPose(
    cname: "下犬式",
    name: 'Adho Mukha Svanasana',
    description:
    '下犬式（Adho Mukha Svanasana）是一種全身伸展姿勢，有助於強化手臂、肩膀和腿部，改善血液循環。從四腳跪姿開始，抬臀向上，形成倒V字形，腳跟盡量向地面壓，手臂和背部保持直線，穩定呼吸。',
    imageName: '下犬式',
    rating: '2 / 5',
  ),
  // 其他瑜伽姿勢
];