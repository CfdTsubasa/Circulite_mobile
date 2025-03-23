import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  Map<String, dynamic> _community = {
    'id': '3',
    'name': 'アニメ好き交流会',
    'description': '最新アニメについて語り合うコミュニティです',
    'members': [
      {'id': '1', 'name': '山田太郎'},
      {'id': '2', 'name': '佐藤花子'},
    ],
    'maxMembers': 4,
    'interests': ['アニメ', 'マンガ', 'コスプレ'],
    'matchScore': 82,
    'events': [
      {
        'id': '1',
        'title': '新作アニメ鑑賞会',
        'date': DateTime.now().add(const Duration(days: 7)),
        'location': '渋谷カフェ',
        'attendees': 2,
      },
    ],
  };

  bool _isMember = false;

  @override
  Widget build(BuildContext context) {
    // 前の画面から渡されたコミュニティデータがあれば更新
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _community = args;

      // コミュニティのメンバーに自分が含まれているかチェック
      if (_community.containsKey('members')) {
        _isMember = (_community['members'] as List).any((member) {
          return member is Map && member['id'] == 'current';
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('コミュニティ詳細'),
        actions: [
          if (_isMember)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // コミュニティオプションメニュー
                _showCommunityOptions();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // コミュニティヘッダー
            Row(
              children: [
                // コミュニティアイコン
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: CirculiteTheme.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _community['name'].substring(0, 1),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: CirculiteTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // コミュニティ情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _community['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: CirculiteTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${_community['members'].length}/${_community['maxMembers']} メンバー',
                            style: const TextStyle(
                              fontSize: 14,
                              color: CirculiteTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (_community.containsKey('matchScore')) ...[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_up,
                              size: 16,
                              color: CirculiteTheme.primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${_community['matchScore']}% マッチ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CirculiteTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // コミュニティ説明
            const Text(
              'コミュニティについて',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                _community['description'],
                style: const TextStyle(
                  fontSize: 16,
                  color: CirculiteTheme.textPrimaryColor,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 趣味タグ
            if (_community.containsKey('interests')) ...[
              const Text(
                '共通の趣味',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    (_community['interests'] as List<String>).map((interest) {
                      return Chip(
                        label: Text(interest),
                        backgroundColor: CirculiteTheme.primaryColor
                            .withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // メンバー一覧
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'メンバー',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // メンバー一覧の詳細表示
                    _showMembersList();
                  },
                  child: const Text('全て表示'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _community['members'].length,
                itemBuilder: (context, index) {
                  final member = _community['members'][index];
                  final isCurrentUser = member['id'] == 'current';

                  return Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              isCurrentUser
                                  ? CirculiteTheme.primaryColor
                                  : Colors.grey.shade300,
                          child: Text(
                            member['name'].substring(0, 1),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  isCurrentUser
                                      ? Colors.white
                                      : CirculiteTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 60,
                          child: Text(
                            member['name'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isCurrentUser
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 予定イベント
            if (_community.containsKey('events') &&
                (_community['events'] as List).isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '予定中のイベント',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_isMember)
                    TextButton.icon(
                      onPressed: () {
                        // イベント作成画面に遷移
                        Navigator.pushNamed(
                          context,
                          '/event',
                          arguments: _community,
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('作成'),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children:
                    (_community['events'] as List).map<Widget>((event) {
                      return _buildEventCard(event);
                    }).toList(),
              ),
              const SizedBox(height: 20),
            ] else if (_isMember) ...[
              const Text(
                'イベント',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.event,
                      size: 40,
                      color: CirculiteTheme.primaryColor,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'まだイベントは予定されていません',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: CirculiteTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton.icon(
                      onPressed: () {
                        // イベント作成画面に遷移
                        Navigator.pushNamed(
                          context,
                          '/event',
                          arguments: _community,
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('イベントを作成'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar:
          _isMember
              ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      // チャットボタン
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // チャット画面に遷移
                            Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: _community,
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text('チャットを開く'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      // 参加ボタン
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // コミュニティ参加処理
                            setState(() {
                              _isMember = true;
                              _community['members'].add({
                                'id': 'current',
                                'name': 'あなた',
                              });
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${_community['name']}に参加しました！'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.group_add),
                          label: const Text('コミュニティに参加'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  // イベントカード
  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // イベントタイトル
            Row(
              children: [
                const Icon(Icons.event, color: CirculiteTheme.primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 日時
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: CirculiteTheme.textSecondaryColor,
                ),
                const SizedBox(width: 10),
                Text(
                  _formatEventDate(event['date']),
                  style: const TextStyle(
                    fontSize: 14,
                    color: CirculiteTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // 場所
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: CirculiteTheme.textSecondaryColor,
                ),
                const SizedBox(width: 10),
                Text(
                  event['location'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: CirculiteTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // 参加人数
            Row(
              children: [
                const Icon(
                  Icons.people,
                  size: 16,
                  color: CirculiteTheme.textSecondaryColor,
                ),
                const SizedBox(width: 10),
                Text(
                  '${event['attendees']} 人が参加予定',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CirculiteTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 参加ボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // イベント詳細表示
                  },
                  child: const Text('詳細'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // イベント参加処理
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${event['title']}に参加しました！'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('参加する'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // イベント日付のフォーマット
  String _formatEventDate(DateTime date) {
    const List<String> weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[date.weekday - 1];

    return '${date.year}/${date.month}/${date.day}（$weekday）${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // メンバー一覧表示
  void _showMembersList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('メンバー一覧'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _community['members'].length,
              itemBuilder: (context, index) {
                final member = _community['members'][index];
                final isCurrentUser = member['id'] == 'current';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isCurrentUser
                            ? CirculiteTheme.primaryColor
                            : Colors.grey.shade300,
                    child: Text(
                      member['name'].substring(0, 1),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            isCurrentUser
                                ? Colors.white
                                : CirculiteTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                  title: Text(
                    member['name'],
                    style: TextStyle(
                      fontWeight:
                          isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing:
                      isCurrentUser
                          ? const Chip(
                            label: Text(
                              'あなた',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: CirculiteTheme.primaryColor,
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.symmetric(horizontal: 8),
                          )
                          : null,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  // コミュニティオプション表示
  void _showCommunityOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('コミュニティを共有'),
                onTap: () {
                  Navigator.pop(context);
                  // 共有処理
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('問題を報告'),
                onTap: () {
                  Navigator.pop(context);
                  // 報告処理
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  'コミュニティを退出',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // 退出確認ダイアログ
                  _showLeaveConfirmation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // コミュニティ退出確認
  void _showLeaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('コミュニティを退出'),
          content: const Text('本当にこのコミュニティから退出しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // コミュニティ退出処理
                setState(() {
                  _isMember = false;
                  _community['members'].removeWhere(
                    (member) => member['id'] == 'current',
                  );
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_community['name']}から退出しました'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('退出する'),
            ),
          ],
        );
      },
    );
  }
}
