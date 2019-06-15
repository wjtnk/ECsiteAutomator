RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  # == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    LABEL_id = 'ユーザID'
    LABEL_email = 'メールアドレス'
    LABEL_max_account = '最大アカウント数'
    LABEL_admin_flg = '管理者権限'
    LABEL_created_at = '作成日時'
    LABEL_updated_at = '更新日時'

    # ここに指定した項目が表示される。include_all_fieldsをすれば全て表示。
    list do
      field :id do
        label LABEL_id
      end
      field :email do
        label LABEL_email
      end
      field :max_account do
        label LABEL_max_account
      end
      field :admin_flg  do
        label LABEL_admin_flg
      end
      field :created_at do
        label LABEL_created_at
      end
      field :updated_at do
        label LABEL_updated_at
      end
    end
  end

  config.model 'Account' do
    LABEL_id = 'アカウントID'
    LABEL_account_email = 'オタマートアカウントメールアドレス'
    LABEL_created_at = '作成日時'
    LABEL_updated_at = '更新日時'

    # ここに指定した項目が表示される。include_all_fieldsをすれば全て表示。
    list do
      field :id do
        label LABEL_id
      end
      field :account_email do
        label LABEL_account_email
      end
      field :created_at do
        label LABEL_created_at
      end
      field :updated_at do
        label LABEL_updated_at
      end
    end
  end

  config.model 'Item' do
    LABEL_id = 'アイテムID'
    LABEL_item_name = '商品名'
    LABEL_description = '商品説明'
    LABEL_price = '商品価格'
    LABEL_image1 = '商品画像1'
    LABEL_image2 = '商品画像2'
    LABEL_image3 = '商品画像3'
    LABEL_image4 = '商品画像4'
    LABEL_category1 = 'オタマートカテゴリー1'
    LABEL_category2 = 'オタマートカテゴリー2'
    LABEL_category3 = 'オタマートカテゴリー3'
    LABEL_state = '商品の状態'
    LABEL_ship_fee = '送料の表示'
    LABEL_ship_method = '発送方法'
    LABEL_ship_from = '発送元の地域'
    LABEL_ship_day = '発送日の目安'
    LABEL_purchase_application = '購入申込みの承諾'
    LABEL_discount = '値下げしませんを表示する'
    LABEL_created_at = '作成日時'
    LABEL_updated_at = '更新日時'

    # ここに指定した項目が表示される。include_all_fieldsをすれば全て表示。
    list do
      field :id do
        label LABEL_id
      end
      field :item_name do
        label LABEL_item_name
      end
      field :description do
        label LABEL_description
      end
      field :price do
        label LABEL_price
      end
      field :image1 do
        label LABEL_image1
      end
      field :image2 do
        label LABEL_image2
      end
      field :image3 do
        label LABEL_image3
      end
      field :image4 do
        label LABEL_image4
      end
      field :category1 do
        label LABEL_category1
      end
      field :category2 do
        label LABEL_category2
      end
      field :category3 do
        label LABEL_category3
      end
      field :state do
        label LABEL_state
      end
      field :ship_fee do
        label LABEL_ship_fee
      end
      field :ship_method do
        label LABEL_ship_method
      end
      field :ship_from do
        label LABEL_ship_from
      end
      field :ship_day do
        label LABEL_ship_day
      end
      field :purchase_application do
        label LABEL_purchase_application
      end
      field :discount  do
        label LABEL_discount
      end
      field :created_at do
        label LABEL_created_at
      end
      field :updated_at do
        label LABEL_updated_at
      end
    end
  end

end
