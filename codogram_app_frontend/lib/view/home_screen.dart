import 'package:flutter/material.dart';
import 'package:codogram_app_frontend/model/movies_model.dart';
import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/utils/utils.dart';
import 'package:codogram_app_frontend/view_model/home_view_model.dart';
import 'package:codogram_app_frontend/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import '../data/response/status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    homeViewModel.fetchMoviesListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserViewModel>(context);
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
              onTap: () {
                userPreference.remove().then((value) {
                  Navigator.pushNamed(context, RoutesName.login);
                });
              },
              child: const Center(child: Text('Logout'))),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: ChangeNotifierProvider<HomeViewModel>(
          create: (BuildContext context) => homeViewModel,
          child: Consumer<HomeViewModel>(builder: (context, value, _) {
            if (value.moviesList.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            } else if (value.moviesList.status == Status.ERROR) {
              return Center(child: Text("Error: ${value.moviesList.message}"));
            } else if (value.moviesList.status == Status.COMPLETED) {
              return ListView.builder(
                  itemCount: value.moviesList.data!.movies!.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: ListTile(
                        leading: Image.network(

                          value.moviesList.data!.movies![index].posterurl.toString(),
                          errorBuilder: (context,error,stack){
                            return const Icon(Icons.error,color: Colors.red,);
                          },
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(value.moviesList.data!.movies![index].title.toString()),
                        subtitle: Text(value.moviesList.data!.movies![index].year.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Utils.averageRating(value.moviesList.data!.movies![index].ratings!).toStringAsFixed(1)),
                            const Icon(Icons.star ,color: Colors.yellow,)
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Container();
          })),
    );
  }
}
