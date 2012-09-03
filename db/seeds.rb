# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
User.create(:account => 'test', :password => 'test', :name => 'テストユーザ')

# Tab.create(:name => 'タブ名')

Garbage.create(:name => '雨傘', :ruby => 'あまがさ', :image_url => 'amagasa.gif', :category_id => '7.0', :note => '布、ビニールは取り外し、もえるごみとして出してください。', :gabage_station => '○', :gabage_station => '?', :keyword1 => '雨', :keyword2 => 'かさ', :keyword3 => 'かっぱ', :keyword4 => '', :keyword5 => '')
Garbage.create(:name => '雨具', :ruby => 'あまぐ', :image_url => 'amagu.gif', :category_id => '10.0', :note => '', :gabage_station => '○', :gabage_station => '○', :keyword1 => '雨', :keyword2 => 'かさ', :keyword3 => 'かっぱ', :keyword4 => '', :keyword5 => '')
Garbage.create(:name => '長靴', :ruby => 'ながぐつ', :image_url => 'nagagutsu.gif', :category_id => '10.0', :note => '', :gabage_station => '○', :gabage_station => '○', :keyword1 => '雨', :keyword2 => 'かさ', :keyword3 => 'かっぱ', :keyword4 => '', :keyword5 => '')
Garbage.create(:name => '', :ruby => '', :image_url => '', :category_id => '', :note => '', :gabage_station => '', :gabage_station => '', :keyword1 => '', :keyword2 => '', :keyword3 => '', :keyword4 => '', :keyword5 => '')
Garbage.create(:name => '', :ruby => '', :image_url => '', :category_id => '', :note => '', :gabage_station => '', :gabage_station => '', :keyword1 => '', :keyword2 => '', :keyword3 => '', :keyword4 => '', :keyword5 => '')
Garbage.create(:name => '', :ruby => '', :image_url => '', :category_id => '', :note => '', :gabage_station => '', :gabage_station => '', :keyword1 => '', :keyword2 => '', :keyword3 => '', :keyword4 => '', :keyword5 => '')

Category.create(:name => '資源物（プラスチック製容器包装）', :cycle => '週1回', :detail => '菓子袋類、カップ・パック類、ボトル類、チューブ類、発砲スチロール類', :detail_url => '', :throw => '指定袋に入れて出してください。', :throw_url => '')
Category.create(:name => '資源物（紙類）', :cycle => '月2回', :detail => '新聞紙・広告・チラシ、本・雑誌、ダンボール、紙パック、その他紙', :detail_url => '', :throw => '紙類はそのまま。', :throw_url => '')
Category.create(:name => '資源物（ペットボトル）', :cycle => '月2回', :detail => 'ペットボトル', :detail_url => '', :throw => 'ペットボトルは専用BOXに。', :throw_url => '')
Category.create(:name => '資源物（缶類）', :cycle => '月1回', :detail => 'アルミ缶、スチール缶', :detail_url => '', :throw => '缶類は専用BOXに。', :throw_url => '')
Category.create(:name => '資源物（衣類（綿製品））', :cycle => '月1回', :detail => '衣服・布', :detail_url => '', :throw => '衣服・布類は透明な袋に。', :throw_url => '')
Category.create(:name => '資源物（びん類）', :cycle => '月1回', :detail => '無色びん、茶色びん、緑色びん、黒色びん、その他びん', :detail_url => '', :throw => '色ごとの専用BOXに。', :throw_url => '')
Category.create(:name => '資源物（その他金属）', :cycle => '年6回', :detail => 'その他金属類、小型家電類', :detail_url => '', :throw => '散らかるものだけ透明な袋で出してください。', :throw_url => '')
Category.create(:name => '資源物（せん定木・落ち葉）', :cycle => '月1〜2回（5月〜12月）', :detail => 'せん定木、落ち葉・刈った草', :detail_url => '', :throw => 'せん定木は基準のサイズで縛って。落ち葉・草は透明な袋で。', :throw_url => '')
Category.create(:name => '資源物（てんぷら油）', :cycle => '年3回', :detail => '植物性てんぷら油', :detail_url => '', :throw => '専用ポリタンクに。', :throw_url => '')
Category.create(:name => '可燃物（もえるごみ）', :cycle => '週2回', :detail => '生ごみ、プラスチック類・革類・ゴム類・アルミホイル等', :detail_url => '', :throw => '指定袋に入れて出してください。', :throw_url => '')
Category.create(:name => '不燃物（うめたてごみ）', :cycle => '年6回', :detail => '茶碗・皿類、ガラス類、植木鉢、電球、アルミガード等', :detail_url => '', :throw => '指定袋に入れて出してください。', :throw_url => '')
Category.create(:name => '有害ごみ', :cycle => '年3回', :detail => '乾電池、水銀温度計・水銀体温計、蛍光灯', :detail_url => '', :throw => '透明な袋に入れて出してください。（蛍光灯は購入時の空き箱で）', :throw_url => '')

CollectDate.create(:area_id => '3.0', :category_id => '1.0', :collect_date => '2012-09-03')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-04')
CollectDate.create(:area_id => '3.0', :category_id => '2.0', :collect_date => '2012-09-05')
CollectDate.create(:area_id => '3.0', :category_id => '3.0', :collect_date => '2012-09-05')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-06')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-07')
CollectDate.create(:area_id => '3.0', :category_id => '1.0', :collect_date => '2012-09-10')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-11')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-14')
CollectDate.create(:area_id => '3.0', :category_id => '6.0', :collect_date => '2012-09-15')
CollectDate.create(:area_id => '3.0', :category_id => '1.0', :collect_date => '2012-09-17')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-18')
CollectDate.create(:area_id => '3.0', :category_id => '4.0', :collect_date => '2012-09-19')
CollectDate.create(:area_id => '3.0', :category_id => '6.0', :collect_date => '2012-09-20')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-21')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-21')
CollectDate.create(:area_id => '3.0', :category_id => '1.0', :collect_date => '2012-09-24')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-25')
CollectDate.create(:area_id => '3.0', :category_id => '8.0', :collect_date => '2012-09-27')
CollectDate.create(:area_id => '3.0', :category_id => '10.0', :collect_date => '2012-09-28')

Area.create(:name => '【1ブロック】高出1〜5区・野村・片丘・郷原・堅石・奈良井')
Area.create(:name => '【2ブロック】大門1〜5番町（泉町）・大門七区（並木町・桔梗町）・宗賀・贄川')
Area.create(:name => '【3ブロック】大門6（幸町）〜8番町・田川町・北小野・塩尻東・木曽平沢')
Area.create(:name => '【4ブロック】原新田・吉田1〜5区・洗馬・朝日村')
Area.create(:name => '')
