import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';
// math パッケージのインポートを追加
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  // ダミーのチャットメッセージ
  final List<Map<String, dynamic>> _messages = [
    {
      'senderId': '1',
      'senderName': '山田太郎',
      'content': 'みなさん、こんにちは！',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'isCurrentUser': false,
    },
    {
      'senderId': '2',
      'senderName': '佐藤花子',
      'content': 'こんにちは！よろしくお願いします。',
      'timestamp': DateTime.now().subtract(
        const Duration(days: 1, hours: 1, minutes: 30),
      ),
      'isCurrentUser': false,
    },
    {
      'senderId': '3',
      'senderName': '鈴木一郎',
      'content': 'はじめまして！よろしくお願いします。',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      'isCurrentUser': false,
    },
    {
      'senderId': 'current',
      'senderName': 'あなた',
      'content': 'みなさん、よろしくお願いします！',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'isCurrentUser': true,
    },
    {
      'senderId': '1',
      'senderName': '山田太郎',
      'content': '今度の土曜日に新作ゲームで遊びませんか？',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isCurrentUser': false,
    },
  ];

  Map<String, dynamic> _community = {
    'id': '1',
    'name': 'ゲーム好き集まれ！',
    'members': [
      {'id': '1', 'name': '山田太郎'},
      {'id': '2', 'name': '佐藤花子'},
      {'id': '3', 'name': '鈴木一郎'},
      {'id': 'current', 'name': 'あなた'},
    ],
    'maxMembers': 4,
  };

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // チャット画面を開いたらスクロールを一番下に
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: CirculiteTheme.textPrimaryColor,
        title: GestureDetector(
          onTap: () {
            // コミュニティ詳細画面に遷移
            Navigator.pushNamed(context, '/community', arguments: _community);
          },
          child: Row(
            children: [
              Hero(
                tag: 'community_${_community['id']}',
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: CirculiteTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    _community['name'].substring(0, 1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CirculiteTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _community['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CirculiteTheme.textPrimaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _community['members'] is List
                          ? '${_community['members'].length}/${_community['maxMembers']} メンバー'
                          : '${_community['members']}/${_community['maxMembers']} メンバー',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.event_outlined,
              color: CirculiteTheme.primaryColor,
            ),
            onPressed: () {
              // イベント作成画面に遷移
              Navigator.pushNamed(context, '/event', arguments: _community);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: CirculiteTheme.textPrimaryColor,
            ),
            onPressed: () {
              // コミュニティ設定メニュー
              _showCommunityOptions();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          image: DecorationImage(
            image: const AssetImage('assets/images/chat_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.05),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            // チャットメッセージ一覧
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(15),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];

                  // 日付が変わる場合に日付表示
                  final showDate = index == 0 || _shouldShowDate(index);

                  return Column(
                    children: [
                      if (showDate) _buildDateDivider(message['timestamp']),
                      _buildMessageBubble(message),
                    ],
                  );
                },
              ),
            ),

            // タイピングインジケーター（テスト用に表示・非表示を切り替え）
            if (_isTyping)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypingDot(delay: 0),
                      _buildTypingDot(delay: 300),
                      _buildTypingDot(delay: 600),
                    ],
                  ),
                ),
              ),

            // 新規メッセージ入力
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SafeArea(
                child: Row(
                  children: [
                    // メディア追加ボタン
                    Container(
                      decoration: BoxDecoration(
                        color: CirculiteTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: CirculiteTheme.primaryColor,
                        onPressed: () {
                          _showMediaOptions();
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // メッセージ入力フィールド
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'メッセージを入力...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          onChanged: (text) {
                            // テスト用にタイピングインジケーターを切り替え
                            setState(() {
                              _isTyping = !_isTyping;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // 送信ボタン
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CirculiteTheme.primaryColor,
                            CirculiteTheme.primaryColor.withBlue(220),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CirculiteTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // タイピングアニメーションドット
  Widget _buildTypingDot({required int delay}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.grey.shade400,
                Colors.grey.shade700,
                (math.sin(value * math.pi * 2 + delay / 1000) + 1) / 2,
              ),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  // 日付表示が必要かチェック
  bool _shouldShowDate(int index) {
    final currentMessage = _messages[index];
    final previousMessage = _messages[index - 1];

    final currentDate = DateTime(
      currentMessage['timestamp'].year,
      currentMessage['timestamp'].month,
      currentMessage['timestamp'].day,
    );

    final previousDate = DateTime(
      previousMessage['timestamp'].year,
      previousMessage['timestamp'].month,
      previousMessage['timestamp'].day,
    );

    return currentDate.difference(previousDate).inDays != 0;
  }

  // 日付区切り
  Widget _buildDateDivider(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }

  // 日付のフォーマット
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return '今日';
    } else if (messageDate == yesterday) {
      return '昨日';
    } else {
      return '${date.year}/${date.month}/${date.day}';
    }
  }

  // 時間のフォーマット
  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // メッセージバブル
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isCurrentUser = message['isCurrentUser'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 送信者アイコン（自分以外）
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                message['senderName'].substring(0, 1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: CirculiteTheme.textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // メッセージ内容
          Column(
            crossAxisAlignment:
                isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              // 送信者名（自分以外）
              if (!isCurrentUser)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  child: Text(
                    message['senderName'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // メッセージバブル
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient:
                      isCurrentUser
                          ? LinearGradient(
                            colors: [
                              CirculiteTheme.primaryColor,
                              CirculiteTheme.primaryColor.withBlue(220),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color: isCurrentUser ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20).copyWith(
                    bottomLeft:
                        !isCurrentUser ? const Radius.circular(0) : null,
                    bottomRight:
                        isCurrentUser ? const Radius.circular(0) : null,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message['content'],
                  style: TextStyle(
                    color:
                        isCurrentUser
                            ? Colors.white
                            : CirculiteTheme.textPrimaryColor,
                    fontSize: 15,
                  ),
                ),
              ),

              // 時間
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message['timestamp']),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: CirculiteTheme.primaryColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // メッセージ送信
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'senderId': 'current',
        'senderName': 'あなた',
        'content': text,
        'timestamp': DateTime.now(),
        'isCurrentUser': true,
      });
      _messageController.clear();
      _isTyping = false;
    });

    // スクロールを一番下に
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // メディア選択オプション表示
  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  '添付ファイルを選択',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildMediaOption(
                    icon: Icons.photo_library,
                    color: Colors.green,
                    label: 'ギャラリー',
                    onTap: () {
                      Navigator.pop(context);
                      _showNotImplementedSnackbar('ギャラリー機能は開発中です');
                    },
                  ),
                  _buildMediaOption(
                    icon: Icons.camera_alt,
                    color: Colors.blue,
                    label: 'カメラ',
                    onTap: () {
                      Navigator.pop(context);
                      _showNotImplementedSnackbar('カメラ機能は開発中です');
                    },
                  ),
                  _buildMediaOption(
                    icon: Icons.location_on,
                    color: Colors.red,
                    label: '位置情報',
                    onTap: () {
                      Navigator.pop(context);
                      _showNotImplementedSnackbar('位置情報機能は開発中です');
                    },
                  ),
                  _buildMediaOption(
                    icon: Icons.insert_drive_file,
                    color: Colors.orange,
                    label: 'ファイル',
                    onTap: () {
                      Navigator.pop(context);
                      _showNotImplementedSnackbar('ファイル添付機能は開発中です');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // メディアオプションアイテム
  Widget _buildMediaOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // コミュニティオプション表示
  void _showCommunityOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'コミュニティオプション',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _buildOptionItem(
                icon: Icons.people,
                color: CirculiteTheme.primaryColor,
                title: 'メンバー一覧',
                onTap: () {
                  Navigator.pop(context);
                  _showMembersList();
                },
              ),
              const Divider(height: 1),
              _buildOptionItem(
                icon: Icons.event,
                color: Colors.orange,
                title: 'イベント作成',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/event', arguments: _community);
                },
              ),
              const Divider(height: 1),
              _buildOptionItem(
                icon: Icons.report_problem_outlined,
                color: Colors.amber,
                title: '問題を報告',
                onTap: () {
                  Navigator.pop(context);
                  _showNotImplementedSnackbar('問題報告機能は開発中です');
                },
              ),
              const Divider(height: 1),
              _buildOptionItem(
                icon: Icons.exit_to_app,
                color: Colors.red,
                title: 'コミュニティを退出',
                onTap: () {
                  Navigator.pop(context);
                  _showLeaveConfirmation();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // オプションアイテム
  Widget _buildOptionItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  // メンバー一覧表示
  void _showMembersList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('メンバー一覧'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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

  // コミュニティ退出確認
  void _showLeaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('コミュニティを退出'),
          content: const Text('本当にこのコミュニティから退出しますか？'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                Navigator.pop(context); // チャット画面を閉じる
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_community['name']}から退出しました'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

  // 未実装機能のスナックバー
  void _showNotImplementedSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
