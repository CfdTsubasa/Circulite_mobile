import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _exploreTabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // ダミーのコミュニティデータ
  final List<Map<String, dynamic>> _myCommunities = [
    {
      'id': '1',
      'name': 'ゲーム好き集まれ！',
      'members': [
        {'id': '1', 'name': '山田太郎'},
        {'id': '2', 'name': '佐藤花子'},
        {'id': '3', 'name': '鈴木一郎'},
      ],
      'maxMembers': 4,
      'lastMessage': '今度の土曜日に新作ゲームで遊びませんか？',
      'lastMessageTime': '10:30',
      'unreadCount': 2,
    },
    {
      'id': '2',
      'name': '週末テニスクラブ',
      'members': [
        {'id': '1', 'name': '山田太郎'},
        {'id': '2', 'name': '佐藤花子'},
        {'id': '3', 'name': '鈴木一郎'},
      ],
      'maxMembers': 4,
      'lastMessage': '次回は日曜の午前9時でいかがでしょうか',
      'lastMessageTime': '昨日',
      'unreadCount': 0,
    },
  ];

  // ダミーのおすすめコミュニティ
  final List<Map<String, dynamic>> _recommendedCommunities = [
    {
      'id': '3',
      'name': 'アニメ好き交流会',
      'description': '最新アニメについて語り合うコミュニティです',
      'members': [
        {'id': '1', 'name': '山田太郎'},
        {'id': '2', 'name': '佐藤花子'},
        {'id': '3', 'name': '鈴木一郎'},
      ],
      'maxMembers': 4,
      'interests': ['アニメ', 'マンガ', 'コスプレ'],
      'matchScore': 82,
    },
    {
      'id': '4',
      'name': 'カメラ散歩部',
      'description': '写真を撮りながら街歩きを楽しむグループです',
      'members': [
        {'id': '1', 'name': '山田太郎'},
        {'id': '2', 'name': '佐藤花子'},
        {'id': '3', 'name': '鈴木一郎'},
      ],
      'maxMembers': 4,
      'interests': ['写真', '散歩', '風景'],
      'matchScore': 75,
    },
    {
      'id': '5',
      'name': '料理研究サークル',
      'description': 'お互いの料理を共有し学び合うコミュニティ',
      'members': [
        {'id': '1', 'name': '山田太郎'},
        {'id': '2', 'name': '佐藤花子'},
        {'id': '3', 'name': '鈴木一郎'},
      ],
      'maxMembers': 4,
      'interests': ['料理', 'パン作り', 'スイーツ'],
      'matchScore': 68,
    },
  ];

  // 興味カテゴリー
  final List<String> _interestCategories = [
    'おすすめ',
    'ゲーム',
    'スポーツ',
    '音楽',
    '映画',
    'アート',
    '料理',
    '旅行',
    '読書',
    '語学',
    'テクノロジー',
    'アウトドア',
  ];

  @override
  void initState() {
    super.initState();
    _exploreTabController = TabController(
      length: _interestCategories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _exploreTabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 画面リスト
    final List<Widget> _screens = [
      _buildHomeTab(),
      _buildExploreTab(),
      _buildChatTab(),
      _buildProfileTab(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: CirculiteTheme.primaryColor,
          unselectedItemColor: CirculiteTheme.textSecondaryColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: '発見',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'チャット',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'プロフィール',
            ),
          ],
        ),
      ),
    );
  }

  // ホームタブ
  Widget _buildHomeTab() {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // アプリバー
          SliverAppBar(
            floating: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Circulite',
              style: TextStyle(
                color: CirculiteTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: CirculiteTheme.textPrimaryColor,
                ),
                onPressed: () {
                  // 通知画面に遷移
                  _showNotImplementedSnackbar('通知機能は開発中です');
                },
              ),
            ],
          ),

          // コンテンツ
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ユーザー向けウェルカムメッセージ
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CirculiteTheme.primaryColor,
                          CirculiteTheme.primaryColor.withBlue(220),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CirculiteTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: CirculiteTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'こんにちは！',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '新しい仲間を見つけましょう',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 所属コミュニティーセクション
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'あなたのコミュニティ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_myCommunities.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2; // チャットタブに切り替え
                            });
                          },
                          child: const Text('すべて表示'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  _myCommunities.isEmpty
                      ? _buildEmptyCommunityView()
                      : Column(
                        children:
                            _myCommunities.map((community) {
                              return _buildCommunityCard(community);
                            }).toList(),
                      ),

                  const SizedBox(height: 30),

                  // 新規コミュニティ作成ボタン
                  if (_myCommunities.length < 4)
                    OutlinedButton.icon(
                      onPressed: () {
                        // コミュニティ作成フロー開始
                        Navigator.pushNamed(context, '/hobby-selection');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('新しいコミュニティを作成'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor: CirculiteTheme.primaryColor,
                        side: BorderSide(color: CirculiteTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // おすすめコミュニティセクション
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'おすすめコミュニティ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 1; // 発見タブに切り替え
                          });
                        },
                        child: const Text('もっと見る'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Column(
                    children:
                        _recommendedCommunities.map((community) {
                          return _buildRecommendedCommunityCard(community);
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // コミュニティがない場合の表示
  Widget _buildEmptyCommunityView() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: CirculiteTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.groups,
              size: 40,
              color: CirculiteTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'まだコミュニティに参加していません',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            '新しいコミュニティを作成するか、おすすめのコミュニティに参加しましょう！',
            textAlign: TextAlign.center,
            style: TextStyle(color: CirculiteTheme.textSecondaryColor),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              // コミュニティ作成フロー開始
              Navigator.pushNamed(context, '/hobby-selection');
            },
            icon: const Icon(Icons.add),
            label: const Text('コミュニティを作成'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              backgroundColor: CirculiteTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // コミュニティカード
  Widget _buildCommunityCard(Map<String, dynamic> community) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          // コミュニティ詳細画面に遷移
          Navigator.pushNamed(context, '/chat', arguments: community);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // コミュニティアイコン
              Hero(
                tag: 'community_${community['id']}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CirculiteTheme.primaryColor.withOpacity(0.7),
                        CirculiteTheme.primaryColor,
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
                  child: Center(
                    child: Text(
                      community['name'].substring(0, 1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // コミュニティ情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            community['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          community['lastMessageTime'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: CirculiteTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      community['lastMessage'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CirculiteTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 16,
                          color: CirculiteTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${community['members']}/${community['maxMembers']} メンバー',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CirculiteTheme.textSecondaryColor,
                          ),
                        ),
                        const Spacer(),
                        if (community['unreadCount'] > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CirculiteTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${community['unreadCount']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }

  // おすすめコミュニティカード
  Widget _buildRecommendedCommunityCard(Map<String, dynamic> community) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          // コミュニティ詳細画面に遷移
          Navigator.pushNamed(context, '/community', arguments: community);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // コミュニティアイコン
                  Hero(
                    tag: 'community_${community['id']}',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CirculiteTheme.primaryColor.withOpacity(0.7),
                            CirculiteTheme.primaryColor,
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
                      child: Center(
                        child: Text(
                          community['name'].substring(0, 1),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // コミュニティ名と説明
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          community['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          community['description'],
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
                  const SizedBox(width: 10),

                  // マッチングスコア
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF42A5F5),
                          CirculiteTheme.primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CirculiteTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${community['matchScore']}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // 興味タグ
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    (community['interests'] as List<String>).map((interest) {
                      return Chip(
                        label: Text(
                          interest,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: CirculiteTheme.primaryColor
                            .withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 15),

              // 参加ボタンとメンバー数
              Row(
                children: [
                  // メンバー数
                  const Icon(
                    Icons.people,
                    size: 16,
                    color: CirculiteTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${community['members']}/${community['maxMembers']} メンバー',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CirculiteTheme.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  // 参加ボタン
                  ElevatedButton(
                    onPressed: () {
                      // コミュニティ参加処理
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${community['name']}に参加しました！'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      minimumSize: const Size(80, 35),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 0,
                      backgroundColor: CirculiteTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('参加する'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 発見タブ
  Widget _buildExploreTab() {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: Colors.white,
              title:
                  _isSearching
                      ? TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'コミュニティを検索...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                            },
                          ),
                        ),
                        autofocus: true,
                      )
                      : const Text(
                        'コミュニティを探す',
                        style: TextStyle(
                          color: CirculiteTheme.textPrimaryColor,
                        ),
                      ),
              actions: [
                if (!_isSearching)
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: CirculiteTheme.textPrimaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
              ],
              bottom: TabBar(
                controller: _exploreTabController,
                isScrollable: true,
                labelColor: CirculiteTheme.primaryColor,
                unselectedLabelColor: CirculiteTheme.textSecondaryColor,
                indicatorColor: CirculiteTheme.primaryColor,
                tabs:
                    _interestCategories.map((category) {
                      return Tab(text: category);
                    }).toList(),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _exploreTabController,
          children:
              _interestCategories.map((category) {
                // カテゴリごとのコミュニティリスト
                // ここではおすすめコミュニティを再利用
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children:
                      _recommendedCommunities.map((community) {
                        return _buildRecommendedCommunityCard(community);
                      }).toList(),
                );
              }).toList(),
        ),
      ),
    );
  }

  // チャットタブ
  Widget _buildChatTab() {
    return SafeArea(
      child:
          _myCommunities.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'チャットはありません',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'コミュニティに参加するとチャットが表示されます',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CirculiteTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // ホームタブに切り替え
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        backgroundColor: CirculiteTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('コミュニティを探す'),
                    ),
                  ],
                ),
              )
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: const Text(
                      'チャット',
                      style: TextStyle(
                        color: CirculiteTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final community = _myCommunities[index];
                        return _buildCommunityCard(community);
                      }, childCount: _myCommunities.length),
                    ),
                  ),
                ],
              ),
    );
  }

  // プロフィールタブ
  Widget _buildProfileTab() {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'プロフィール',
              style: TextStyle(
                color: CirculiteTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: CirculiteTheme.textPrimaryColor,
                ),
                onPressed: () {
                  // 設定画面に遷移
                  _showNotImplementedSnackbar('設定画面は開発中です');
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // プロフィールヘッダー
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CirculiteTheme.primaryColor.withOpacity(0.8),
                          CirculiteTheme.primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CirculiteTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // プロフィール写真
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: CirculiteTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ユーザー名
                        const Text(
                          'ユーザー名',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // メールアドレス
                        const Text(
                          'user@example.com',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),

                        // プロフィール編集ボタン
                        ElevatedButton.icon(
                          onPressed: () {
                            // プロフィール編集画面に遷移
                            _showNotImplementedSnackbar('プロフィール編集は開発中です');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('プロフィールを編集'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: CirculiteTheme.primaryColor,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 統計情報
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.groups,
                          value: _myCommunities.length.toString(),
                          label: 'コミュニティ',
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        _buildStatItem(
                          icon: Icons.event,
                          value: '0',
                          label: 'イベント',
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        _buildStatItem(
                          icon: Icons.star,
                          value: '0',
                          label: '趣味',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 設定メニュー
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.notifications_none,
                          title: '通知設定',
                          onTap: () {
                            _showNotImplementedSnackbar('通知設定は開発中です');
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingItem(
                          icon: Icons.lock_outline,
                          title: 'プライバシー設定',
                          onTap: () {
                            _showNotImplementedSnackbar('プライバシー設定は開発中です');
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingItem(
                          icon: Icons.help_outline,
                          title: 'ヘルプとサポート',
                          onTap: () {
                            _showNotImplementedSnackbar('ヘルプとサポートは開発中です');
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingItem(
                          icon: Icons.info_outline,
                          title: 'アプリについて',
                          onTap: () {
                            _showNotImplementedSnackbar('アプリ情報は開発中です');
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ログアウトボタン
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // ログアウト処理
                          _showLogoutConfirmation();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 10),
                              Text(
                                'ログアウト',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 統計アイテム
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: CirculiteTheme.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // 設定項目ウィジェット
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(icon, color: CirculiteTheme.textPrimaryColor, size: 22),
              const SizedBox(width: 15),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  // ログアウト確認ダイアログ
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('ログアウト'),
            content: const Text('ログアウトしてもよろしいですか？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('キャンセル'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // ログアウト処理
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ログアウト'),
              ),
            ],
          ),
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
