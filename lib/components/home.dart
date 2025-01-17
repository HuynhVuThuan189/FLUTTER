import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuan08/app/data/api.dart';
import 'package:tuan08/app/model/category.dart';
import 'package:tuan08/app/model/product.dart';
import 'package:tuan08/components/product_detail.dart';
import 'package:tuan08/components/show_product.dart';
import 'package:tuan08/lintinh/footer.dart';
import 'package:tuan08/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _imagesSlider = [
    "https://static.vecteezy.com/system/resources/previews/000/334/460/large_2x/coffee-place-logo-vector.jpg",
    "https://logoregion.com/wp-content/uploads/2019/03/coffee.jpg",
    "https://mir-s3-cdn-cf.behance.net/project_modules/fs/55f708202329419.66843710ed81b.jpg",
  ];

  List<CategoryModel> _listCateModel = [];
  List<ProductModel> _listProductModel = [];

  Future<List<CategoryModel>> getListCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListCategory(accountID, token);
  }

  Future<List<ProductModel>> getMyListProduct() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accountID = pref.getString("accountID")!;
    String token = pref.getString("token")!;
    return await APIRepository().getListProduct(accountID, token);
  }

  void getAllListProduct() async {
    _listProductModel = await getMyListProduct();
    for (var element in _listProductModel) {
      print(element.name);
    }
  }

  void getAllListCate() async {
    _listCateModel = await getListCategory();
  }

  bool checkfavorite = false;

  @override
  void initState() {
    super.initState();
    getAllListCate();
    getAllListProduct();
    checkfavorite = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder<List<CategoryModel>>(
                future: getListCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('không có loại sản phẩn nào'),
                    );
                  }

                  List<CategoryModel> _listCateModel = snapshot.data!;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: _listCateModel.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowProductPage(
                                        cate: _listCateModel[index]),
                                  ))
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Colors.blueAccent,
                                          Colors.pinkAccent
                                        ]),
                                        border: Border.all(
                                            width: 2,
                                            color: const Color.fromARGB(
                                                255, 214, 214, 214))),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _listCateModel[index].imageURL!),
                                      radius:
                                          35, // Set a fixed radius for the avatar
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    _listCateModel[index].name,
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverToBoxAdapter(
              child: CarouselSlider(
                items: _imagesSlider
                    .map((item) => Container(
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Set your desired border radius here
                              child: Image.network(
                                item,
                                fit: BoxFit
                                    .cover, // Adjust the image fit property as needed
                                width: 1000.0,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2,
                  onPageChanged: (index, reason) {
                    // Handle page change if needed
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<ProductModel>>(
                future: getMyListProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Không có sản phẩm nào'),
                    );
                  }

                  List<ProductModel> _listProduct = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 30, top: 8),
                      child: SizedBox(
                        height: 650,
                        child: MasonryGridView.builder(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                          productModel: _listProduct[index]),
                                    ));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 184, 30),
                                ),
                                child: Column(
                                  children: [
                                    Hero(
                                      tag: _listProduct[index].id!,
                                      child: Image.network(
                                          _listProduct[index].imageURL!),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(_listProduct[index].name!),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  formatMoney(
                                                      _listProduct[index]
                                                          .price!),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                checkfavorite = !checkfavorite;
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.discount,
                                                color: Color.fromARGB(
                                                    255, 197, 178, 8),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: _listProduct.length,
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
