import 'package:codogram_app_frontend/view/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../data/response/status.dart';
import '../view_model/feed_view_model.dart';

class FeedView extends StatefulWidget {

  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final FeedViewModel feedViewModel = FeedViewModel();

  @override

  void initState() {
    super.initState();
    feedViewModel.fetchPostFeed();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FeedViewModel>.value(
      value: feedViewModel,
      child: Builder(
        builder: (context) {
          final model = Provider.of<FeedViewModel>(context);
          switch (model.postFeed.status) {
            case Status.LOADING:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case Status.ERROR:
              return Scaffold(
                body: Center(child: Text("Error: ${model.postFeed.message}")),
              );
            case Status.COMPLETED:
              final posts = model.postFeed.data?.data ?? [];

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Codogram",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[Colors.purple, Colors.blue],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    // 🔥 Story avatars
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.blue, Colors.pink],
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {},
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(post.user?.avatar ?? ''),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  post.user?.username ?? '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // 🔥 Feed Posts
                    Expanded(
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          final media = post.media ?? [];
                          final pageController = PageController();

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF000000),
                                  Color(0xFF2C3E50)
                                ], // Black to dark blue
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            post.user?.avatar ?? ''),
                                        radius: 20,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        post.user?.username ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.white),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.more_horiz,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  Text(
                                    post.title ?? '',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  if (media.isNotEmpty)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 250,
                                          child: PageView.builder(
                                            controller: pageController,
                                            itemCount: media.length,
                                            itemBuilder: (context, mediaIndex) {
                                              final url = media[mediaIndex];
                                              final isVideo =
                                                  url.endsWith(".mp4");

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          FullScreenMedia(
                                                              url: url),
                                                    ),
                                                  );
                                                },
                                                child: isVideo
                                                    ? VideoPlayerWidget(
                                                        url: url)
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                          url,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SmoothPageIndicator(
                                          controller: pageController,
                                          count: media.length,
                                          effect: WormEffect(
                                            dotColor:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey.shade700
                                                    : Colors.grey.shade300,
                                            activeDotColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            dotHeight: 8,
                                            dotWidth: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        post.user?.username ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          post.description ?? '',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Row(
                                    children: [
                                      Text(
                                        '❤️',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      SizedBox(width: 8),
                                      Text('🔥'),
                                      SizedBox(width: 8),
                                      Text('😂'),
                                      SizedBox(width: 8),
                                      Text('👍'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Tags: ${post.tags?.join(', ') ?? ''}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[200])),
                                  Text(
                                    "Posted: ${post.createdAt?.substring(0, 10) ?? ''}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class FullScreenMedia extends StatelessWidget {
  final String url;
  const FullScreenMedia({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final isVideo = url.endsWith('.mp4');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isVideo
            ? VideoPlayerWidget(url: url)
            : InteractiveViewer(
                child: Image.network(url),
              ),
      ),
    );
  }
}
