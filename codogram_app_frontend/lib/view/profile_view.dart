import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/profile_view_model.dart';
import '../data/response/status.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchCurrentUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>.value(
      value: _viewModel,
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          final profileResponse = model.userProfile;

          switch (profileResponse.status) {
            case Status.LOADING:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case Status.ERROR:
              return Scaffold(
                body: Center(
                  child: Text(
                    profileResponse.message ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            case Status.COMPLETED:
              final user = profileResponse.data?.data;
              if (user == null) {
                return const Scaffold(
                  body: Center(child: Text("No user data found")),
                );
              }

              return Scaffold(
                backgroundColor: const Color(0xFF0f0f0f),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.purpleAccent, Colors.blueAccent],
                    ).createShader(bounds),
                    child: Text(
                      user.username ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(user.avatar ?? ''),
                              backgroundColor: Colors.grey.shade800,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.username ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.bio ?? 'No bio added',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat("Posts", user.postsCount?.toString() ?? "0"),
                                _buildStat("Followers", user.followersCount?.toString() ?? "0"),
                                _buildStat("Following", user.followingCount?.toString() ?? "0"),
                                _buildStat("Skills", user.skills?.length.toString() ?? "0"),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to Edit Profile
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text("Edit Profile"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Posts",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Media Grid Section
                      user.posts != null && user.posts!.isNotEmpty
                          ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user.posts!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final post = user.posts![index];
                          final mediaUrl = post.media?.isNotEmpty == true
                              ? post.media!.first
                              : null;

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: mediaUrl != null
                                ? Image.network(
                              mediaUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, color: Colors.grey);
                              },
                            )
                                : const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      )
                          : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "No posts yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            default:
              return const Scaffold(
                body: Center(child: Text("Unknown state")),
              );
          }
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
