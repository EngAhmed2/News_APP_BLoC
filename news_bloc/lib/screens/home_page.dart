import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_bloc/cubits/news_cubit.dart';
import 'package:news_bloc/screens/article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().getNews();
  }

  bool connect = true;
  void changeConnection(bool _) {
    connect = _;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsCubit>().getNews();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'News',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Color(0xff231F20),
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Color(0xffE9EEFA),

            // For Android (dark icons)
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: const Color(0xffE9EEFA),
          elevation: 0,
        ),
        body: BlocListener<NewsCubit, NewsState>(
          listener: (context, state) {
            if (state is NewsConnectionFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Check Internet Connection!!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<NewsCubit, NewsState>(
            builder: (context, state) {
              if (state is NewsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                );
              }
              if (state is NewsSuccess) {
                changeConnection(true);
                final data = state.news.articles;
                return Container(
                  margin: const EdgeInsets.only(
                    top: 24,
                  ),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleScreen(
                                news: data[index],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          trailing: Container(
                            height: 80,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  data[index].urlToImage ??
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMxghWKz3Gq_0VKVTyEwzr-t5V9MtXxpQmeA&usqp=CAU',
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            data[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff231F20),
                            ),
                          ),
                          subtitle: Text(
                            data[index].source.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Color(0xff6D6265),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is NewsFailed) {
                return GestureDetector(
                  onTap: () => context.read<NewsCubit>().getNews(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/newsFailed.png"),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'There is an error try again',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff5FCAFB),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is NewsConnectionFailed) {
                changeConnection(false);
                return GestureDetector(
                  onTap: () => context.read<NewsCubit>().getNews(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/newsSignalSearching.png"),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'No Internet Connection',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff5FCAFB),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text('There is an error try again'),
              );
            },
          ),
        ),
      ),
    );
  }
}

//FutureBuilder(
//           future: topBusinessNews,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.blueAccent,
//                 ),
//               );
//             }
//             if (snapshot.hasData == true) {
//               final data = snapshot.data!.articles;
//               return Container(
//                 margin: const EdgeInsets.only(
//                   top: 24,
//                 ),
//                 child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ArticleScreen(
//                                   news: data[index],
//                                 ),
//                           ),
//                         );
//                       },
//                       child: ListTile(
//                         trailing: Container(
//                           height: 80,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               fit: BoxFit.fill,
//                               image: NetworkImage(
//                                 data[index].urlToImage ??
//                                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMxghWKz3Gq_0VKVTyEwzr-t5V9MtXxpQmeA&usqp=CAU',
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           data[index].title,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xff231F20),
//                           ),
//                         ),
//                         subtitle: Text(
//                           data[index].source.name,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xff6D6265),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//
//             if (snapshot.hasError) {
//                 return Center(
//                     child: Image.asset('assets/images/SignalSearching.png'));
//             }
//             return const Center(child: Text('There is an error try again'));
//           },
//         ),
