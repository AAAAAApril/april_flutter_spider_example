///TODO 剧集实体（电影、电视剧的每一集信息）
class EpisodesBean {
  const EpisodesBean({
    required this.title,
    required this.id,
  });

  ///这一集的标题
  final String title;

  ///这一集的 ID
  final String id;
}
