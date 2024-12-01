enum Weekday {
  monday('월'),
  tuesday('화'),
  wednesday('수'),
  thursday('목'),
  friday('금'),
  saturday('토'),
  sunday('일');

  const Weekday(this.shortKorean);

  final String shortKorean;
  String get longKorean => '$shortKorean요일';
  String get short => name[0];
  String get middle => name.substring(0, 3);
  String get long => name;
}