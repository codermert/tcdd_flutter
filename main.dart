import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ticket_widget/ticket_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tren Bileti Arama',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1C2331),
        primaryColor: Color(0xFF1C2331),
      ),
      home: TrainTicketSearchScreen(),
    );
  }
}

class TrainTicketSearchScreen extends StatefulWidget {
  @override
  _TrainTicketSearchScreenState createState() => _TrainTicketSearchScreenState();
}

class _TrainTicketSearchScreenState extends State<TrainTicketSearchScreen> {
  String? from;
  String? to;
  DateTime selectedDate = DateTime.now();
  List<dynamic> tickets = [];
  final List<String> stations = [
    'Adana', 'Adapazarı', 'Ankara', 'Istanbul', 'Izmir', 'Konya', 'Samsun',
    'Adana', 'Adana (Kiremithane)', 'Adapazarı', 'Adnanmenderes Havaalanı',
    'Afyon A.Çetinkaya', 'Ahmetler', 'Ahmetli', 'Akdağmadeni YHT', 'Akgedik',
    'Akhisar', 'Aksakal', 'Akçadağ', 'Akçamağara', 'Akşehir', 'Alayunt',
    'Alayunt Müselles', 'Alaşehir', 'Alifuatpaşa', 'Aliköy', 'Alp', 'Alpu',
    'Alpullu', 'Alöve', 'Amasya', 'Ankara Gar', 'Araplı', 'Argıthan', 'Arifiye',
    'Artova', 'Arıkören', 'Asmakaya', 'Atça', 'Avşar', 'Aydın', 'Ayran',
    'Ayrancı', 'Ayvacık', 'Aşkale', 'Bahçe', 'Bahçeli (Km.755+290 S)',
    'Bahçeşehir', 'Bahçıvanova', 'Bakır', 'Balıkesir', 'Balıkesir (Gökköy)',
    'Balıköy', 'Balışıh', 'Banaz', 'Bandırma Şehir', 'Baraklı', 'Baskil',
    'Batman', 'Battalgazi', 'Bağıştaş', 'Bedirli', 'Belemedik', 'Bereket',
    'Beyhan', 'Beylikköprü', 'Beylikova', 'Beyoğlu', 'Beşiri', 'Bilecik',
    'Bilecik YHT', 'Bismil', 'Biçer', 'Bor', 'Bostankaya', 'Bozkanat',
    'Bozkurt', 'Bozüyük', 'Bozüyük YHT', 'Boğaziçi', 'Boğazköprü',
    'Boğazköprü Müselles', 'Boğazköy', 'Buharkent', 'Burdur', 'Böğecik',
    'Büyükderbent YHT', 'Büyükçobanlar', 'Caferli', 'Ceyhan', 'Cürek',
    'Dazkırı', 'Demirdağ', 'Demiriz', 'Demirkapı', 'Demirli', 'Demiryurt',
    'Demirözü', 'Denizli', 'Derince YHT', 'Değirmenözü', 'Değirmisaz',
    'Diliskelesi YHT', 'Dinar', 'Divriği', 'Diyarbakır', 'Doğançay',
    'Doğanşehir', 'Dumlupınar', 'Durak', 'Dursunbey', 'Döğer', 'ERYAMAN YHT',
    'Edirne', 'Ekerek', 'Ekinova', 'Elazığ', 'Elmadağ', 'Emiralem', 'Emirler',
    'Erbaş', 'Ereğli', 'Ergani', 'Eriç', 'Erzincan', 'Erzurum', 'Eskişehir',
    'Evciler', 'Eşme', 'Fevzipaşa', 'Fırat', 'Gazellidere', 'Gaziantep',
    'Gaziemir', 'Gazlıgöl', 'Gebze', 'Genç', 'Germencik', 'Germiyan', 'Gezin',
    'Goncalı', 'Goncalı Müselles', 'Gökçedağ', 'Gökçekısık', 'Gölbaşı',
    'Gölcük', 'Gömeç', 'Göçentaşı', 'Güllübağ', 'Gümüş', 'Gümüşgün',
    'Gündoğan', 'Güneyköy', 'Güneş', 'Güzelbeyli', 'Güzelyurt', 'Hacıbayram',
    'Hacıkırı', 'Hacırahmanlı', 'Hanlı', 'Hasankale', 'Havza', 'Hekimhan',
    'Hereke YHT', 'Himmetdede', 'Horasan', 'Horozköy', 'Horozluhan', 'Horsunlu',
    'Huzurkent', 'Hüyük', 'Ildızım', 'Ilgın', 'Ilıca', 'Irmak', 'Isparta',
    'Ispartakule', 'Kabakça', 'Kadılı', 'Kadınhan', 'Kaklık', 'Kalecik',
    'Kalkancık', 'Kalın', 'Kandilli', 'Kangal', 'Kanlıca', 'Kapaklı',
    'Kapıdere İstasyonu', 'Kapıkule', 'Karaali', 'Karaağaçlı', 'Karabük',
    'Karaisalıbucağı', 'Karakuyu', 'Karaköy', 'Karalar', 'Karaman', 'Karaosman',
    'Karasenir', 'Karasu', 'Karaurgan', 'Karaözü', 'Kars', 'Kavak',
    'Kavaklıdere', 'Kayabaşı', 'Kayabeyli', 'Kayaş', 'Kayseri', 'Kayseri (İncesu)',
    'Kayışlar', 'Kaşınhan', 'Kelebek', 'Kemah', 'Kemaliye Çaltı', 'Kemerhisar',
    'Keykubat', 'Keçiborlu', 'Kireç', 'Km. 30+500', 'Km. 37+362', 'Km.102+600',
    'Km.139+500', 'Km.156 Durak', 'Km.171+000', 'Km.176+000', 'Km.186+000',
    'Km.282+200', 'Km.286+500', 'Konaklar', 'Konya', 'Konya (Selçuklu YHT)',
    'Kozdere', 'Kumlu Sayding', 'Kunduz', 'Kurbağalı', 'Kurfallı', 'Kurt',
    'Kurtalan', 'Kuyucak', 'Kuşcenneti', 'Kuşsarayı', 'Köprüağzı', 'Köprüköy',
    'Köprüören', 'Köşk', 'Kürk', 'Kütahya', 'Kılıçlar', 'Kırkağaç',
    'Kırıkkale', 'Kırıkkale YHT', 'Kızoğlu', 'Kızılca', 'Kızılinler', 'Ladik',
    'Lalahan', 'Leylek', 'Lüleburgaz', 'Maden', 'Malatya', 'Mamure', 'Manisa',
    'Mazlumlar', 'Menderes', 'Menemen', 'Mercan', 'Meydan', 'Mezitler',
    'Meşelidüz', 'Mithatpaşa', 'Muradiye', 'Muratlı', 'Mustafayavuz', 'Muş',
    'Narlı', 'Nazilli', 'Nizip', 'Niğde', 'Nohutova', 'Nurdağ', 'Nusrat',
    'Ortaklar', 'Osmancık', 'Osmaneli', 'Osmaniye', 'Oturak', 'Ovasaray',
    'Oymapınar', 'Palandöken', 'Palu', 'Pamukören', 'Pancar', 'Pazarcık',
    'Paşalı', 'Pehlivanköy', 'Piribeyler', 'Polatlı', 'Polatlı YHT', 'Porsuk',
    'Pozantı', 'Pınarbaşı', 'Pınarlı', 'Rahova', 'Sabuncupınar', 'Salat',
    'Salihli', 'Sallar', 'Samsun', 'Sandal', 'Sandıklı', 'Sapanca', 'Sarayköy',
    'Sarayönü', 'Saruhanlı', 'Sarıdemir', 'Sarıkamış', 'Sarıkent',
    'Sarımsaklı', 'Sarıoğlan', 'Savaştepe', 'Sağlık', 'Sekili', 'Selçuk',
    'Sevindik', 'Seyitler', 'Sincan', 'Sindirler', 'Sinekli', 'Sivas',
    'Sivas(Adatepe)', 'Sivrice', 'Soma', 'Sorgun YHT', 'Soğucak', 'Subaşı',
    'Sudurağı', 'Sultandağı', 'Sultanhisar', 'Suluova', 'Susurluk',
    'Suveren', 'Suçatı', 'Söke', 'Söğütlü Durak', 'Süngütaşı', 'Sünnetçiler',
    'Sütlaç', 'Sıcaksu', 'Tanyeri', 'Tatvan Gar', 'Tavşanlı', 'Tayyakadın',
    'Taşkent', 'Tecer', 'Tepeköy', 'Tokat(Yeşilyurt)', 'Topaç', 'Topdağı',
    'Topulyurdu', 'Torbalı', 'Turgutlu', 'Turhal', 'Tuzhisar', 'Tüney',
    'Türkoğlu', 'Tınaztepe', 'Ulam', 'Uluköy', 'Ulukışla', 'Uluova',
    'Umurlu', 'Urganlı', 'Uyanık', 'Uzunköprü', 'Uşak', 'Velimeşe', 'Vezirhan',
    'Yahşihan', 'Yahşiler', 'Yakapınar', 'Yarbaşı', 'Yarımca YHT', 'Yayla',
    'Yaylıca', 'Yazlak', 'Yazıhan', 'Yağdonduran', 'Yeni Karasar', 'Yenice',
    'Yenice D', 'Yenifakılı', 'Yenikangal', 'Yeniköy', 'Yeniçubuk', 'Yerköy',
    'Yeşilhisar', 'Yolçatı', 'Yozgat YHT', 'Yunusemre', 'Yurt', 'Yıldırımkemal',
    'Yıldızeli', 'Zile', 'Çadırkaya', 'Çakmak', 'Çalıköy', 'Çamlık', 'Çankırı',
    'Çardak', 'Çatalca', 'Çavundur', 'Çavuşcugöl', 'Çay', 'Çağlar', 'Çelikalan',
    'Çerikli', 'Çerkezköy', 'Çerkeş', 'Çetinkaya', 'Çiftehan', 'Çiftlik',
    'Çizözü', 'Çiğli', 'Çobanhasan', 'Çorlu', 'Çukurbük', 'Çukurhüseyin',
    'Çumra', 'Çöltepe', 'Çöğürler', 'İhsaniye', 'İliç', 'İnay', 'İncirlik',
    'İncirliova', 'İsabeyli', 'İshakçelebi', 'İsmetpaşa', 'İstanbul(Bakırköy)',
    'İstanbul(Bostancı)', 'İstanbul(Halkalı)', 'İstanbul(Pendik)', 'İstanbul(Söğütlüçeşme)',
    'İzmir (Basmane)', 'İzmit YHT', 'Şakirpaşa', 'Şarkışla', 'Şefaatli',
    'Şefkat', 'Şehitlik', 'Şerbettar'
  ];



  Future<void> searchTickets() async {
    if (from == null || to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen nereden ve nereye istasyonlarını seçin.')),
      );
      return;
    }
    final response = await http.get(Uri.parse(
        'https://tcdd-api.vercel.app/search?nereden=$from&nereye=$to&tarih=${selectedDate.toIso8601String().split('T')[0]}'));

    if (response.statusCode == 200) {
      setState(() {
        tickets = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bilet bulunamadı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nereye Gitmek İstersiniz?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Icon(Icons.train_outlined, color: Colors.white),
                ],
              ),
              SizedBox(height: 20),
              _buildDropdownField('Nereden', from, (String? newValue) {
                setState(() {
                  from = newValue;
                });
              }),
              _buildDropdownField('Nereye', to, (String? newValue) {
                setState(() {
                  to = newValue;
                });
              }),
              _buildDateField(),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: searchTickets,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton('Bileti hemen bul', Icons.train, true),
                      SizedBox(width: 30),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketDetailScreen(ticket: ticket),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(ticket['trenAdi'], style: TextStyle(color: Colors.white)),
                          subtitle: Text('${ticket['binisTarih']} - ${ticket['inisTarih']}', style: TextStyle(color: Colors.grey)),
                        ),
                      ).animate(

                        effects: [
                          FadeEffect(duration: 300.ms),
                          SlideEffect(
                            begin: Offset(0.3, 0), // Dikey kaydırma
                            end: Offset.zero,
                            duration: 300.ms,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF1C2331),
        selectedItemColor: Color(0xFFFFA500),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, IconData icon, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFFFA500) : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          suffixIcon: Icon(Icons.train, color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA500)),
          ),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
        items: stations.map((String station) {
          return DropdownMenuItem<String>(
            value: station,
            child: Text(station),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Tarih seç',
          labelStyle: TextStyle(color: Colors.grey),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFA500)),
          ),
        ),
        style: TextStyle(color: Colors.white),
        controller: TextEditingController(text: selectedDate.toLocal().toString().split(' ')[0]),
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
          );
          if (picked != null && picked != selectedDate) {
            setState(() {
              selectedDate = picked;
            });
          }
        },
      ),
    );
  }
}

class TicketDetailScreen extends StatelessWidget {
  final dynamic ticket;

  TicketDetailScreen({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF1C2331),
      appBar: AppBar(
        title: Text('Bilet Detayı'),
        backgroundColor:  Color(0xFF1C2331),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 710,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ticket['vagonTipleri'].length,
                itemBuilder: (context, index) {
                  final vagon = ticket['vagonTipleri'][index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TicketWidget(
                      width: 350,
                      height: 500,
                      isCornerRounded: true,
                      padding: EdgeInsets.all(40),
                      child: TicketData(ticket: ticket, vagon: vagon),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketData extends StatelessWidget {
  final dynamic ticket;
  final dynamic vagon;

  const TicketData({
    Key? key,
    required this.ticket,
    required this.vagon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final binisTarihSaat = ticket['binisTarih'].split(' ');
    final inisTarihSaat = ticket['inisTarih'].split(' ');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120.0,
                height: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(width: 1.0, color: Colors.green),
                ),
                child: Center(
                  child: Text(
                    '${ticket['seferId'].toString()}',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ),
              Image.network(
                'https://telegra.ph/file/c6a883fa4c3fbfe7fc849.png',
                width: 100,
                height: 80,
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Sefer Seçimi',
            style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          ticketDetailsWidget('Tren Adı', ticket['trenAdi'], 'Tarih', binisTarihSaat[0]+ ' ' + binisTarihSaat[1]+ ' ' + binisTarihSaat[2]),
          ticketDetailsWidget('Kalkış', binisTarihSaat[3] + ' ' + binisTarihSaat[4], 'Varış', inisTarihSaat[3]+ ' ' + inisTarihSaat[4]),
          ticketDetailsWidget('Tren Tipi', ticket['trenTipi'], 'Gün Notu', ticket['gunNotu']),
          ticketDetailsWidget('Vagon Tipi', vagon['vagonTip'], 'Kalan Koltuk', '${vagon['kalanSayi']}'),
          ticketDetailsWidget('Ücret', '${vagon['toplamUcret']} TL', 'Kalan Yatak', '${vagon['kalanYatakSayisi']}'),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://quickchart.io/qr?text=ebilet.tcddtasimacilik.gov.tr&size=200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              '@codermert | UPO Software Technologies',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc, String secondTitle, String secondDesc) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(firstTitle, style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(firstDesc, style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(secondTitle, style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(secondDesc, style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
        )
      ],
    ),
  );
}