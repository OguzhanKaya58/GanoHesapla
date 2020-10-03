import 'package:flutter/material.dart';
import 'dart:math' as mat;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDeger = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(
            child: Text(
          "GANO Hesapla",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return uygulamaGovdesi();
        } else {
          return uygulamaGovdesiLandscape();
        }
      }),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //STATİC FORMU TUTAN CONTAİNER
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //color: Colors.pink.shade50,
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          hintText: "Ders Adını Giriniz",
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                          labelStyle:
                              TextStyle(fontSize: 22, color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2)),
                          focusedBorder: (OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey, width: 2))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.length > 0) {
                            return null;
                          } else
                            return "Lütfen Ders Adını Giriniz";
                        },
                        onSaved: (kaydedilecekDeger) {
                          dersAdi = kaydedilecekDeger;
                          setState(() {
                            tumDersler.add(Ders(dersAdi, dersHarfDeger,
                                dersKredi, rasgeleRenkOlustur()));
                            ortalama = 0;
                            ortalamayiHesapla();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: dersKrediItems(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueGrey, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          DropdownButtonHideUnderline(
                            child: Container(
                              child: DropdownButton<double>(
                                items: dersHarfDegerleriItems(),
                                value: dersHarfDeger,
                                onChanged: (secilenHarf) {
                                  setState(() {
                                    dersHarfDeger = secilenHarf;
                                  });
                                },
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blueGrey, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 70,
              //color: Colors.blueGrey,
              decoration: BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(color: Colors.blueGrey, width: 2),
                    bottom: BorderSide(color: Colors.blueGrey, width: 2)),
              ),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: tumDersler.length == 0
                        ? "Lütfen Ders Ekleyin"
                        : "Ortalama : ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: tumDersler.length == 0
                        ? ""
                        : "${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 30,
                      color: (ortalama < 2) ? Colors.red : Colors.green,
                    ),
                  ),
                ]),
              )),
            ),
          ),
          //DİNAMİC LİSTE TUTAN CONTAİNER
          Expanded(
            child: Container(
                // color: Colors.orange.shade50,
                child: ListView.builder(
              itemBuilder: _listeElemanlariniOlustur,
              itemCount: tumDersler.length,
            )),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKrediItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      //  var Krediler = DropdownMenuItem<int>(value: i,child: Text("$i Kredi"),);
      //  krediler.add(Krediler);
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Kredi",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "AA",
          style: TextStyle(fontSize: 25),
        ),
        value: 4,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "BA",
          style: TextStyle(fontSize: 25),
        ),
        value: 3.5,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "BB",
          style: TextStyle(fontSize: 25),
        ),
        value: 3,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "CB",
          style: TextStyle(fontSize: 25),
        ),
        value: 2.5,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "CC",
          style: TextStyle(fontSize: 25),
        ),
        value: 2,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "DC",
          style: TextStyle(fontSize: 25),
        ),
        value: 1.5,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "DD",
          style: TextStyle(fontSize: 25),
        ),
        value: 1,
      ),
    );
    harfler.add(
      DropdownMenuItem(
        child: Text(
          "FF",
          style: TextStyle(fontSize: 25),
        ),
        value: 0,
      ),
    );
    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 8, 3 , 8),
        decoration: BoxDecoration(
            border: Border.all(color: tumDersler[index].renk, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.assignment,
              color: Colors.blueGrey,
              size: 30,
            ),
          ),
          title: Text(
            tumDersler[index].dersAdi,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 30,
              color: Colors.blueGrey,
            ),
          ),
          subtitle: Text(
            "Kredi :" +
                tumDersler[index].kredi.toString() +
                "\t\tNot :" +
                tumDersler[index].harfDegeri.toString(),
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var onakiDers in tumDersler) {
      var kredi = onakiDers.kredi;
      var harfDegeri = onakiDers.harfDegeri;
      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color rasgeleRenkOlustur() {
    return Color.fromARGB(
        150 + mat.Random().nextInt(105),
        150 + mat.Random().nextInt(105),
        150 + mat.Random().nextInt(105),
        150 + mat.Random().nextInt(105));
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  //color: Colors.pink.shade50,
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Ders Adı",
                                hintText: "Ders Adını Giriniz",
                                hintStyle: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                labelStyle: TextStyle(
                                    fontSize: 22, color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey, width: 2)),
                                focusedBorder: (OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 2),
                                )),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                              ),
                              validator: (girilenDeger) {
                                if (girilenDeger.length > 0) {
                                  return null;
                                } else
                                  return "Lütfen Ders Adını Giriniz";
                              },
                              onSaved: (kaydedilecekDeger) {
                                dersAdi = kaydedilecekDeger;
                                setState(() {
                                  tumDersler.add(Ders(dersAdi, dersHarfDeger,
                                      dersKredi, rasgeleRenkOlustur()));
                                  ortalama = 0;
                                  ortalamayiHesapla();
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      items: dersKrediItems(),
                                      value: dersKredi,
                                      onChanged: (secilenKredi) {
                                        setState(() {
                                          dersKredi = secilenKredi;
                                        });
                                      },
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                DropdownButtonHideUnderline(
                                  child: Container(
                                    child: DropdownButton<double>(
                                      items: dersHarfDegerleriItems(),
                                      value: dersHarfDeger,
                                      onChanged: (secilenHarf) {
                                        setState(() {
                                          dersHarfDeger = secilenHarf;
                                        });
                                      },
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 4),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueGrey, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    //color: Colors.blueGrey,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      border: BorderDirectional(
                          top: BorderSide(color: Colors.blueGrey, width: 2),
                          bottom: BorderSide(color: Colors.blueGrey, width: 2)),
                    ),
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: tumDersler.length == 0
                              ? "Lütfen Ders Ekleyin"
                              : "Ortalama : ",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: tumDersler.length == 0
                              ? ""
                              : "${ortalama.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 30,
                            color: (ortalama < 2) ? Colors.red : Colors.green,
                          ),
                        ),
                      ]),
                    )),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  // color: Colors.orange.shade50,
                  child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              )),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class Ders {
  String dersAdi;
  double harfDegeri;
  int kredi;
  Color renk;

  Ders(this.dersAdi, this.harfDegeri, this.kredi, this.renk);
}
