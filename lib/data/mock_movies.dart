import '../models/movie.dart';

const mockMovies = [
  Movie(
    id: 1,
    title: '별빛 아래 우리',
    genre: '드라마',
    year: 2024,
    posterAsset: 'assets/images/posters/hero_under_the_starlight.jpg',
    averageRating: 4.5,
    synopsis: '별빛이 쏟아지는 여름밤, 오래된 약속을 따라 다시 만난 두 사람의 이야기입니다.',
  ),
  Movie(
    id: 2,
    title: '심연을 걷는 자',
    genre: '스릴러',
    year: 2023,
    posterAsset: 'assets/images/posters/poster_abyss_walker.jpg',
    averageRating: 4.2,
    synopsis: '깊은 심연에 감춰진 비밀을 추적하는 한 탐험가의 긴장감 넘치는 여정입니다.',
  ),
  Movie(
    id: 3,
    title: '공허의 메아리',
    genre: 'SF',
    year: 2025,
    posterAsset: 'assets/images/posters/poster_echoes_of_the_void.jpg',
    averageRating: 4.3,
    synopsis: '우주 끝에서 수신된 의문의 신호를 따라 미지의 공간으로 향합니다.',
  ),
  Movie(
    id: 4,
    title: '네 번째 오후',
    genre: '드라마',
    year: 2024,
    posterAsset: 'assets/images/posters/poster_fourth_afternoon.jpg',
    averageRating: 4.0,
    synopsis: '평범한 오후에 찾아온 네 번의 우연이 서로의 일상을 바꿉니다.',
  ),
  Movie(
    id: 5,
    title: '밤의 그림자',
    genre: '스릴러',
    year: 2022,
    posterAsset: 'assets/images/posters/poster_night_shadows.jpg',
    averageRating: 4.1,
    synopsis: '잠들지 않는 도시에서 사라진 흔적을 쫓는 미스터리 스릴러입니다.',
  ),
  Movie(
    id: 6,
    title: '속삭이는 숲',
    genre: '애니메이션',
    year: 2025,
    posterAsset: 'assets/images/posters/poster_whispering_woods.jpg',
    averageRating: 4.6,
    synopsis: '말을 잃은 숲의 목소리를 되찾기 위해 떠나는 따뜻한 모험입니다.',
  ),
];

Movie? findMovieById(int id) {
  for (final movie in mockMovies) {
    if (movie.id == id) return movie;
  }
  return null;
}
