// 0주차 콘솔 출력 연습을 위해 print를 사용함
// ignore_for_file: avoid_print

class Movie {
  const Movie({required this.title, required this.year});

  final String title;
  final int year;
}

String nicknameOrDefault(String? nickname) {
  return nickname ?? '게스트';
}

void main() {
  const List<Movie> movies = [
    Movie(title: '인터스텔라', year: 2014),
    Movie(title: '기생충', year: 2019),
    Movie(title: '인사이드 아웃', year: 2015),
  ];

  for (final movie in movies) {
    print(movie.title);
  }

  String? nickname;
  final safeNickname = nicknameOrDefault(nickname);
  print('닉네임: $safeNickname');

  nickname = '무비러버';
  print('닉네임: ${nicknameOrDefault(nickname)}');
}
