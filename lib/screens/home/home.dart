import 'package:cat_breeds/model/cat.dart';
import 'package:cat_breeds/screens/home/cat_detail.dart';
import 'package:cat_breeds/service/cat_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<Cat>> futureCats;
  List<Cat> allCats = [];
  List<Cat> filteredCats = [];
  bool filtered = false;
  bool _isLoading = false;
  int _page = 0;
  TextEditingController searchController = TextEditingController();
  String _previousQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCats();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (filtered) {
          filterCats(searchController.text);
        } else {
          _fetchCats();
        }
      }
    });
  }

  void filterCats(String query) async {
    if (query == _previousQuery)
      return; // No hacer nada si el query no ha cambiado
    _previousQuery = query;
    filtered = true;
    CatService().fetchCatName(query).then((filteredCatsList) {
      setState(() {
        allCats = filteredCatsList;
      });
    });
  }

  Future<void> _fetchCats() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Cat> newCats = await CatService().fetchCats(page: _page, limit: 10);
      setState(() {
        _page++;
        allCats.addAll(newCats);
      });
    } catch (e) {
      // Manejo de errores
      print('Error fetching cats: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Catbreeds',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
                onSubmitted: filterCats,
              ),
            ),
            Expanded(
                child: allCats.isEmpty && _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: allCats.length + 1,
                        itemBuilder: (context, index) {
                          if (index == allCats.length) {
                            return _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox.shrink();
                          }
                          Cat cat = allCats[index];
                          return Column(
                            children: [
                              Card(
                                margin: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(cat.name),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CatDetail(cat: cat),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Más',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Image.network(cat.imageurl ??
                                          'https://via.placeholder.com/150'),
                                      SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'País de origen',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4.0),
                                              Text(
                                                cat.origin,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Inteligencia',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4.0),
                                              Text(
                                                cat.intelligence.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        })),
          ],
        ),
      ),
    );
  }
}
