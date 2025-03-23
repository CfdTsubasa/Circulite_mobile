import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0);

  Map<String, dynamic> _community = {};

  // 推奨スポット（広告）
  final List<Map<String, dynamic>> _recommendedVenues = [
    {
      'id': '1',
      'name': 'カフェ テラス',
      'address': '東京都渋谷区宇田川町XX-XX',
      'type': 'カフェ',
      'image': 'assets/images/cafe.jpg',
      'distance': '500m',
      'rating': 4.5,
    },
    {
      'id': '2',
      'name': 'ゲームバー Switch',
      'address': '東京都新宿区歌舞伎町X-XX',
      'type': 'バー',
      'image': 'assets/images/bar.jpg',
      'distance': '1.2km',
      'rating': 4.2,
    },
    {
      'id': '3',
      'name': 'レストラン SAKURA',
      'address': '東京都渋谷区道玄坂X-X',
      'type': 'レストラン',
      'image': 'assets/images/restaurant.jpg',
      'distance': '800m',
      'rating': 4.7,
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 前の画面から渡されたコミュニティデータがあれば更新
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _community = args;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント作成'),
        backgroundColor: Colors.white,
        foregroundColor: CirculiteTheme.textPrimaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // コミュニティ名表示
              if (_community.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: CirculiteTheme.primaryColor
                            .withOpacity(0.2),
                        child: Text(
                          _community['name'].substring(0, 1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CirculiteTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'コミュニティ',
                              style: TextStyle(
                                fontSize: 12,
                                color: CirculiteTheme.textSecondaryColor,
                              ),
                            ),
                            Text(
                              _community['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // イベントタイトル
              const Text(
                'イベントタイトル',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'イベントタイトルを入力',
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // 日付選択
              const Text(
                '日付',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: CirculiteTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: CirculiteTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 時間選択
              const Text(
                '時間',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: CirculiteTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _formatTime(_selectedTime),
                        style: const TextStyle(
                          fontSize: 16,
                          color: CirculiteTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 場所
              const Text(
                '場所',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: '場所を入力',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '場所を入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // おすすめスポット（広告）
              const Text(
                'おすすめスポット',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recommendedVenues.length,
                  itemBuilder: (context, index) {
                    final venue = _recommendedVenues[index];
                    return _buildVenueCard(venue);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 説明
              const Text(
                'イベント説明（オプション）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'イベントの詳細説明を入力',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 30),

              // 作成ボタン
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // イベント作成処理
                    _createEvent();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: CirculiteTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text('イベントを作成'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // おすすめスポットカード
  Widget _buildVenueCard(Map<String, dynamic> venue) {
    return GestureDetector(
      onTap: () {
        // スポットを選択
        setState(() {
          _locationController.text = '${venue['name']} (${venue['address']})';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${venue['name']}を選択しました'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // スポット画像（ダミー）
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                gradient: LinearGradient(
                  colors: [
                    getColorForVenueType(venue['type']).withOpacity(0.7),
                    getColorForVenueType(venue['type']),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(
                  venue['type'] == 'カフェ'
                      ? Icons.coffee
                      : venue['type'] == 'バー'
                      ? Icons.local_bar
                      : Icons.restaurant,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // スポット名
                  Text(
                    venue['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // スポットタイプ
                  Text(
                    venue['type'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: CirculiteTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // 距離と評価
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: CirculiteTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        venue['distance'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: CirculiteTheme.textSecondaryColor,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        venue['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: CirculiteTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 会場タイプに基づく色を返す
  Color getColorForVenueType(String type) {
    switch (type) {
      case 'カフェ':
        return Colors.green;
      case 'バー':
        return Colors.purple;
      case 'レストラン':
        return Colors.orange;
      default:
        return CirculiteTheme.primaryColor;
    }
  }

  // 日付選択
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CirculiteTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 時間選択
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CirculiteTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // 日付のフォーマット
  String _formatDate(DateTime date) {
    const List<String> weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[date.weekday - 1];

    return '${date.year}年${date.month}月${date.day}日（$weekday）';
  }

  // 時間のフォーマット
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // イベント作成処理
  void _createEvent() {
    // イベント日時の作成
    final eventDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // イベント情報
    final newEvent = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'date': eventDateTime,
      'attendees': 1, // 作成者自身
    };

    // ここではダミーの成功処理
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('イベントを作成しました！'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // 前の画面に戻る
    Navigator.pop(context);
  }
}
