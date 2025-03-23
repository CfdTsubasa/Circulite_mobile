import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';

class HobbySelectionScreen extends StatefulWidget {
  const HobbySelectionScreen({Key? key}) : super(key: key);

  @override
  State<HobbySelectionScreen> createState() => _HobbySelectionScreenState();
}

class _HobbySelectionScreenState extends State<HobbySelectionScreen> {
  final TextEditingController _customHobbyController = TextEditingController();
  final List<String> _selectedHobbies = [];

  // カテゴリー別趣味リスト
  final Map<String, List<String>> _hobbyCategories = {
    'ゲーム': [
      'RPG',
      'FPS',
      'アクション',
      'パズル',
      'シミュレーション',
      '音ゲー',
      'スマホゲーム',
      '格闘ゲーム',
      'カードゲーム',
      'ボードゲーム',
    ],
    'スポーツ': [
      '野球',
      'サッカー',
      'バスケットボール',
      'テニス',
      'ゴルフ',
      '水泳',
      'ジョギング',
      'ヨガ',
      'ジム',
      'ボルダリング',
      'サイクリング',
    ],
    '音楽': [
      'J-POP',
      'ロック',
      'アニソン',
      'K-POP',
      'クラシック',
      'ジャズ',
      'ヒップホップ',
      'EDM',
      '楽器演奏',
      'カラオケ',
      'フェス',
    ],
    '映画・ドラマ': [
      'アクション',
      'コメディ',
      'ホラー',
      'SF',
      'アニメ',
      '恋愛',
      '洋画',
      '邦画',
      'K-ドラマ',
      'Netflix',
      'Disney+',
    ],
    'アウトドア': [
      'キャンプ',
      '釣り',
      'BBQ',
      'ハイキング',
      '旅行',
      '写真撮影',
      '海',
      '山',
      '温泉',
      'ドライブ',
      '公園',
    ],
    'その他': [
      '読書',
      '料理',
      'ファッション',
      'ショッピング',
      'カフェ巡り',
      '映画館',
      'アート',
      'DIY',
      'コレクション',
      'ペット',
      '植物',
    ],
  };

  // 現在選択中のカテゴリー
  String _currentCategory = 'ゲーム';

  @override
  void dispose() {
    _customHobbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('趣味を選択')),
      body: SafeArea(
        child: Column(
          children: [
            // カテゴリータブ
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children:
                    _hobbyCategories.keys.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: _currentCategory == category,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _currentCategory = category;
                              });
                            }
                          },
                          backgroundColor: Colors.white,
                          selectedColor: CirculiteTheme.primaryColor,
                          labelStyle: TextStyle(
                            color:
                                _currentCategory == category
                                    ? Colors.white
                                    : CirculiteTheme.textPrimaryColor,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const Divider(),

            // 次へボタン
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed:
                    _selectedHobbies.isEmpty
                        ? null
                        : () {
                          Navigator.pushNamed(context, '/matching');
                        },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text('次へ'),
              ),
            ),

            // 趣味選択グリッド
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '興味のある趣味を選択してください（最大10個）',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 趣味チップグリッド
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          _hobbyCategories[_currentCategory]!.map((hobby) {
                            final isSelected = _selectedHobbies.contains(hobby);
                            return FilterChip(
                              label: Text(hobby),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    if (_selectedHobbies.length < 10) {
                                      _selectedHobbies.add(hobby);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('趣味は最大10個まで選択できます'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } else {
                                    _selectedHobbies.remove(hobby);
                                  }
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: CirculiteTheme.primaryColor
                                  .withOpacity(0.2),
                              checkmarkColor: CirculiteTheme.primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? CirculiteTheme.primaryColor
                                        : CirculiteTheme.textPrimaryColor,
                              ),
                            );
                          }).toList(),
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
}
