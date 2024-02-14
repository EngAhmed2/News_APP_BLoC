import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/models/top_business_news.dart';
import 'package:news/repository/news_repository.dart';
import 'package:news/screens/news_detail.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  Future<TopBusinessNews>? topBusinessNews;
  @override
  void initState() {
    topBusinessNews = NewsRepository().getTopBusinessNews();
    super.initState();
  }
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        setState()=>topBusinessNews = NewsRepository().getTopBusinessNews();
      },
      child: Scaffold(
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
        body: FutureBuilder(
            future:topBusinessNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                );
              }
              if (snapshot.hasData == true) {
                final data = snapshot.data!.articles;
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
                              builder: (context) => NewsDetail(
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

              if(snapshot.hasError){
                connection();
                if(_isConnected== false){
                  return Center(child: Image.asset('assets/images/SignalSearching.png'));
                }
              }
              return const Center(child: Text('There is an error try again'));

            },
        ),
      ),
    );
  }
  bool _isConnected = true;
  void connection() async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState() {
        return _isConnected = false;
      }
    }
    else {
      setState(){
        _isConnected = true;
      }
    }
  }
}
