require 'csv'

CSV.generate do |csv|
    csv_column_names = %w(商品名	商品説明	商品画像1	商品画像2	商品画像3	商品画像4	商品価格	在庫数	仕入れ価格	送料	備考	管理番号	カテゴリ	ブランド	サイズ	商品の状態	配送料の負担	配送方法	発送元の地域	発送までの日付	フリルカテゴリ	フリルサイズ	フリルブランド	フリル商品の状態	フリル配送料の負担	フリル配送方法	フリル発送日の目安	フリル発送元の地域	フリル購入申請	ラクマカテゴリ	ラクマサイズ	ラクマブランド	ラクマ商品の状態	ラクマ配送料の負担	ラクマ配送方法	ラクマ発送元の地域	ラクマ発送までの日付	オタマートカテゴリー1	オタマートカテゴリー2	オタマートカテゴリー3	タグ	商品の状態	送料の表示	発送方法	発送元の地域	発送日の目安	購入申込みの承諾	値下げしませんを表示する)
   #%w(氏名 アドレス)はrubyのリテラルの一つで、["氏名","アドレス"]と同値になります。
    csv << csv_column_names
  @account.items.each do |item|
    csv_column_values = [
        item.item_name,
        item.description,
        item.image1,
        item.image2,
        item.image3,
        item.image4,
        item.price,
        "","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",
        item.category1,
        item.category2,
        item.category3,
        item.tags,
        item.state,
        item.ship_fee,
        item.ship_method,
        item.ship_from,
        item.ship_day,
        item.purchase_application,
        item.discount,
    ]
    csv << csv_column_values
  end
end
