import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({Key? key}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  bool _isLoading = true;
  
  // ダミーのおすすめユーザーデータ
  final List<Map<String, dynamic>> _recommendedUsers = [
    {
      'name': '山田太郎',
      'age': 24,
      'bio': 'ゲームとアニメが好きです。特にRPGが得意です。',
      'hobbies': ['RPG', 'アニメ', 'カラオケ', '映画鑑賞'],
      'matchScore': 87,
    },
    {
      'name': '佐藤花子',
      'age': 22,
      'bio': 'テニスとカフェ巡りが趣味です。新しい友達作りたいです！',
      'hobbies': ['テニス', 'カフェ巡り', '料理', '映画鑑賞'],
      'matchScore': 75,
    },
    {
      'name': '鈴木一郎',
      'age': 26,
      'bio': 'サッカー観戦が趣味です。週末は友達とフットサルしてます。',
      'hobbies': ['サッカー', 'フットサル', 'スポーツ観戦', 'ビール'],
      'matchScore': 68,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    // マッチング処理をシミュレート
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('おすすめの仲間'),
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _buildMatchingResults(),
    );
  }
  
  // ローディング表示
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CirculiteTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'あなたに合う仲間を探しています...',
            style: TextStyle(
              fontSize: 16,
              color: CirculiteTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  // マッチング結果表示
  Widget _buildMatchingResults() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'あなたと相性の良い ${_recommendedUsers.length} 人の仲間が見つかりました！',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: _recommendedUsers.length,
            itemBuilder: (context, index) {
              final user = _recommendedUsers[index];
              return _buildUserCard(user);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              // コミュニティ作成処理
              // ホーム画面に遷移
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('コミュニティを作成する'),
          ),
        ),
      ],
    );
  }
  
  // ユーザーカード
  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ユーザーアイコン
                CircleAvatar(
                  radius: 30,
                  backgroundColor: CirculiteTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    user['name'].substring(0, 1),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CirculiteTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // ユーザー情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user['name']} (${user['age']})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user['bio'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CirculiteTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // マッチングスコア
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: CirculiteTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${user['matchScore']}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // 趣味タグ
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (user['hobbies'] as List<String>).map((hobby) {
                return Chip(
                  label: Text(
                    hobby,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: CirculiteTheme.primaryColor.withOpacity(0.1),
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            // 追加ボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // ユーザー情報詳細表示
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('詳細'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // ユーザーを仲間に追加
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user['name']}さんを仲間に追加しました！'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('追加'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
