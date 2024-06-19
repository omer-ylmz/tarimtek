import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/adversite_detay.dart';
import 'package:tarimtek/viewmodel/all_ilan_model.dart';

class HomePage extends StatefulWidget {
  final AppUser user;

  const HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: const Text("İlanlar"),
      ),
      body: Consumer<AllIlanModel>(
        builder: (context, model, child) {
          if (model.state == AllIlanViewState.Busy &&
              model.ilanlarListesi!.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllIlanViewState.Loaded) {
            var filteredIlanlarListesi = model.ilanlarListesi!
                .where((ilan) => ilan.ilanSahibiId != widget.user.userId)
                .toList();

            if (filteredIlanlarListesi.isEmpty) {
              return _ilanYok();
            }

            return RefreshIndicator(
              onRefresh: model.refresh,
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: model.hasMoreLoading
                    ? filteredIlanlarListesi.length + 1
                    : filteredIlanlarListesi.length,
                itemBuilder: (context, index) {
                  if (index < filteredIlanlarListesi.length) {
                    return _ilanListeElemaniOlustur(
                        filteredIlanlarListesi[index]);
                  } else {
                    return _yeniElemanlarYukleniyorIndicator();
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _ilanListeElemaniOlustur(Ilan ilan) {
    return GestureDetector(
      onTap: () {
        print("ilana tıklandı " + ilan.ilanTanimi!);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => AdversiteDetay(
              ilan: ilan,
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                ilan.isPozisyonu!,
                style: Sabitler.yaziStyleSiyahBaslik,
              ),
            ),
            Expanded(
              child: Container(
                height: 200, // Resim yüksekliği
                width: double.infinity - 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://static.ticimax.cloud/35637/uploads/urunresimleri/buyuk/cig-ic-findik-7dcb.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₺" + ilan.isUcreti! + "/" + ilan.isSuresi!,
                    style: Sabitler.yaziStyleSiyahBaslik,
                  ),
                  Text(
                    ilan.selectedIlce! + ", " + ilan.selectedIl!,
                    style: Sabitler.yaziStyleSiyahAltBaslik,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _yeniElemanlarYukleniyorIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void dahaFazlaIlanGetir() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final _tumIlanModel = Provider.of<AllIlanModel>(context, listen: false);
    await _tumIlanModel.dahaFazlaIlanGetir();

    setState(() {
      _isLoading = false;
    });
  }

  void _listeScrollListener() {
    final _tumIlanlarModel = Provider.of<AllIlanModel>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        _tumIlanlarModel.hasMoreLoading &&
        !_isLoading) {
      dahaFazlaIlanGetir();
    }
  }

  Future<void> _refreshIlanListYoksa() async {
    final _tumIlanModel = Provider.of<AllIlanModel>(context, listen: false);
    await _tumIlanModel.refresh();
  }

  Widget _ilanYok() {
    return RefreshIndicator(
      onRefresh: _refreshIlanListYoksa,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.no_backpack_outlined,
                  color: Colors.green,
                  size: 80,
                ),
                Text(
                  "Henüz İlan Yok",
                  style: Sabitler.yaziMorStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
