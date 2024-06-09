import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/pages/konusma_page.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class KullanicilarSayfasi extends StatefulWidget {
  const KullanicilarSayfasi({Key? key}) : super(key: key);

  @override
  State<KullanicilarSayfasi> createState() => _KullanicilarSayfasiState();
}

class _KullanicilarSayfasiState extends State<KullanicilarSayfasi> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Future<List<AppUser>?> allUsersFuture = _userModel.getAllUser();
    return Scaffold(
      backgroundColor: Sabitler.arkaplan,
      appBar: AppBar(
        backgroundColor: Sabitler.ikinciRenk,
        title: const Text("Kullanıcılar"),
      ),
      body: FutureBuilder<List<AppUser>?>(
        future: allUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Hata: ${snapshot.error}",
                style: Sabitler.yaziMorStyle,
              ),
            );
          } else if (snapshot.hasData) {
            var allUsers = snapshot.data!;
            allUsers
                .removeWhere((user) => user.userId == _userModel.user!.userId);

            if (allUsers.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshUserList,
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    var user = allUsers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => KonusmaPage(
                            currentUser: _userModel.user!,
                            sohbetEdilenUser: user,
                          ),
                        ));
                      },
                      child: ListTile(
                        title: Text(user.userName!),
                        subtitle: Text(user.email!),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilURL!),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
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
                            Icons.supervised_user_circle_sharp,
                            color: Colors.green,
                            size: 80,
                          ),
                          Text(
                            "Henüz Kullanıcı Yok",
                            style: Sabitler.yaziMorStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onRefresh: _refreshUserList,
              );
            }
          } else {
            return Center(
              child: Text(
                "Kayıtlı bir kullanıcı yok",
                style: Sabitler.yaziMorStyle,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _refreshUserList() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }
}
