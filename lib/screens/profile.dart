import 'package:flutter/material.dart';
import 'package:circulite/utils/theme.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  String _selectedGender = '未選択';
  int _age = 20;
  bool _locationEnabled = true;
  
  final List<String> _genderOptions = ['未選択', '男性', '女性', 'その他', '回答しない'];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール作成'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // プロフィール写真
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: CirculiteTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // 写真アップロード処理
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // 名前入力
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'ニックネーム *',
                    hintText: 'あなたの表示名を入力してください',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ニックネームを入力してください';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // 年齢選択
                const Text(
                  '年齢 *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Slider(
                  value: _age.toDouble(),
                  min: 18,
                  max: 80,
                  divisions: 62,
                  label: _age.toString(),
                  activeColor: CirculiteTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _age = value.toInt();
                    });
                  },
                ),
                Center(
                  child: Text(
                    '$_age 歳',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 性別選択
                const Text(
                  '性別',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedGender,
                      items: _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 自己紹介
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: '自己紹介',
                    hintText: 'あなたについて教えてください（趣味、特技など）',
                    alignLabelWithHint: true,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 位置情報設定
                SwitchListTile(
                  title: const Text('位置情報を有効にする'),
                  subtitle: const Text('近くのコミュニティを見つけやすくなります'),
                  value: _locationEnabled,
                  activeColor: CirculiteTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (bool value) {
                    setState(() {
                      _locationEnabled = value;
                    });
                  },
                ),
                
                const SizedBox(height: 30),
                
                // 次へボタン
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // プロフィール情報保存処理
                      // 次のステップ（趣味選択）に進む
                      Navigator.pushNamed(context, '/hobby-selection');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('次へ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
