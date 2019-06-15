class ItemsController < ApplicationController
    require "csv"
    require "zip"
    require 'fileutils'

    before_action :authenticate_user!
    before_action :current_user_check, only: [:show, :edit, :update, :destroy, :exhibit]

    def index
        @account = Account.find(params[:account_id])
        @items = @account.items.all
    end

    def item_exhibited
        @account = Account.find(params[:account_id])
        @items_exhibited = @account.items.where.not(url: nil)
        # @items = @account.items.all
    end

    def item_not_exhibit
        @account = Account.find(params[:account_id])
        @items_not_exhibited = @account.items.where(url: nil)
    end

    def create
      @account = Account.find(params[:account_id])
      uploaded_file = item_params[:csv]
      hash_name = uploaded_file.hash.to_s
      if Time.now - @account.access_time > 120
              #ファイルの保存先
              output_path = Rails.root.join('public/zip_store',  hash_name + uploaded_file.original_filename)
              #ファイル保存
              File.open(output_path, 'wb') do |f|
                f.write  uploaded_file.read
              end
              Zip::File.open(output_path) do |zip|
                        zip.each do |entry|
                            destination = Rails.root.join('public/zip_store',  hash_name + "/")
                            dir = File.join(destination, File.dirname(entry.name))
                            FileUtils.mkpath(dir)
                                        zip.extract(entry, destination + entry.name) { true }
                                                    if entry.name == "exhibit/item.csv"
                                                                    begin
                                                                         CSV.table(destination + "exhibit/item.csv",encoding: 'Shift_JIS:UTF-8').each do |row| #windowsの時
                                                                            csv_insert(row,hash_name)
                                                                         end
                                                                    rescue
                                                                         CSV.table(destination + "exhibit/item.csv").each do |row| #macの時
                                                                            csv_insert(row,hash_name)
                                                                         end
                                                                    end
                                                    end
                        end
              end
              # multi_exhibit #登録した後にすぐに出品
     end
      logger.debug "#{Time.now - @account.access_time}"
      redirect_to account_path(@account)
    end

    def multi_exhibit
        @account = Account.find(params[:account_id])
        if Time.now - @account.access_time > 120 #現在の時刻と前回の時刻との差が60(新しいリクエストが送られるまで)より大きければtrue
            logger.debug "#{Time.now - @account.access_time}"
            logger.debug '#######pass###########'
            logger.info  'LOGGER TEST >>> info'
            @account.access_time =  Time.now
            @account.save

            @ota = Otamart.new
            driver = @ota.login(@account.account_email,@account.account_password)
            n = 1
            items = @account.random_exhibit ? @account.items.where(url:nil).order("RANDOM()") : @account.items.where(url:nil)#ランダム出品するかどうか
                for item in items.all do #driver.closeしなければならないため、スコープを作らないfor分を使用。
                         file_abs_path = Rails.root.join('public/zip_store', item.csv.to_s + "/exhibit/")
                         @account.access_time =  Time.now#ここで出品中は常に時間を更新することで、2回目に送られてくるリクエストが、Time.now - @account.access_time > 60にtrueにならないようにする
                         @account.save
                         logger.debug '#######after_pass############'
                         logger.debug "#{Time.now - @account.access_time}"
                         logger.debug "#{n}"
                         logger.info  'LOGGER TEST >>> info'
                         url, driver = @ota.multi_exhibit(driver,file_abs_path,item.image1,item.image2,item.image3,item.image4,item.item_name,item.description,item.category1,item.category2,item.category3,
                             item.tags,item.state,item.ship_fee,item.ship_method,item.ship_from,item.ship_day,item.purchase_application,item.discount,item.price)
                         item.url = url
                         item.save

                         unless  @account.min_interval.blank? or @account.max_interval.blank?
                               logger.debug "#{Random.new().rand(@account.min_interval.to_i...@account.max_interval.to_i)}"
                               sleep(Random.new().rand(@account.min_interval.to_i..@account.max_interval.to_i))
                           else
                               sleep(Random.new().rand(5.0..15.0))
                          end

                        n += 1
                        @account.access_time =  Time.now#ここで出品中は常に時間を更新することで、2回目に送られてくるリクエストが、Time.now - @account.access_time > 60にtrueにならないようにする
                        @account.save
                end
            driver.close
            driver.quit
        else
            logger.debug "#{Time.now - @account.access_time}"
            logger.debug '#######no############'
            logger.info  'LOGGER TEST >>> info'
        end
    end


    def csv_insert(row,hash_name)
            @item = @account.items.new(item_params)
            @item.csv = hash_name
            @item.item_name = row[0]
            @item.description = row[1]
            @item.image1 = row[2]
            @item.image2 = row[3]
            @item.image3 = row[4]
            @item.image4 = row[5]
            @item.price = row[6]
            @item.category1 = row[-11]
            @item.category2 = row[-10]
            @item.category3 = row[-9]
            @item.tags = row[-8]
            @item.state = row[-7]
            @item.ship_fee = row[-6]
            @item.ship_method = row[-5]
            @item.ship_from = row[-4]
            @item.ship_day = row[-3]
            @item.purchase_application = row[-2]
            @item.discount = row[-1]
            @item.count_comments = 0
            @item.new_comment = false
            #ここで保存失敗した時の挙動を設定する
            @item.save
    end


    def show
        @item = Item.find(params[:id])
        @account = @item.account
        @comments = @item.comments.all
    end

    def edit
        @item = Item.find(params[:id])
        @account = @item.account
    end

    def update
        @item = Item.find(params[:id])
        @account = @item.account
            if Time.now - @account.access_time > 10 #現在の時刻と前回の時刻との差が60(新しいリクエストが送られるまで)より大きければtrue
                    logger.debug "#{Time.now - @account.access_time}"
                    logger.debug '#######pass###########'
                    @account.access_time =  Time.now
                    @account.save

                    if !item_update_params[:image1].blank?
                        uploaded_file1 = item_update_params[:image1]
                        file_abs_path1 = Rails.root.join('public/zip_store', @item.csv.to_s + "/exhibit/" + uploaded_file1.original_filename)
                    	File.open(file_abs_path1, 'w+b') do |fp|
                    	    fp.write  uploaded_file1.read
                    	end
                        image1 = uploaded_file1.original_filename
                    else
                        image1 = ""
                    end

                    if !item_update_params[:image2].blank?
                        uploaded_file2 = item_update_params[:image2]
                        file_abs_path2 = Rails.root.join('public/zip_store', @item.csv.to_s + "/exhibit/" + uploaded_file2.original_filename)
                        File.open(file_abs_path2, 'w+b') do |fp|
                          fp.write  uploaded_file2.read
                        end
                        image2 = uploaded_file2.original_filename
                    else
                        image2 = ""
                    end

                    if !item_update_params[:image3].blank?
                        uploaded_file3 = item_update_params[:image3]
                        file_abs_path3 = Rails.root.join('public/zip_store', @item.csv.to_s + "/exhibit/" + uploaded_file3.original_filename)
                        File.open(file_abs_path3, 'w+b') do |fp|
                          fp.write  uploaded_file3.read
                        end
                        image3 = uploaded_file3.original_filename
                    else
                        image3 = ""
                    end

                    if !item_update_params[:image4].blank?
                        uploaded_file4 = item_update_params[:image4]
                        file_abs_path4 = Rails.root.join('public/zip_store', @item.csv.to_s + "/exhibit/" + uploaded_file4.original_filename)
                        File.open(file_abs_path4, 'w+b') do |fp|
                          fp.write  uploaded_file4.read
                        end
                        image4 = uploaded_file4.original_filename
                    else
                        image4 = ""
                    end

                    @ota = Otamart_edit.new
                    driver = @ota.login(@account.account_email,@account.account_password,@item.url.gsub("comments","edit"))
                    file_abs_path = Rails.root.join('public/zip_store', @item.csv.to_s + "/exhibit/")

                    result = @ota.item_edit(driver,file_abs_path, image1, image2,image3,image4,
                                    params[:item][:item_name], params[:item][:description], params[:item][:category1], params[:item][:category2],
                                    params[:item][:category3], params[:item][:tags], params[:item][:state], params[:item][:ship_fee],
                                    params[:item][:ship_method], params[:item][:ship_from], params[:item][:ship_day],
                                    params[:item][:purchase_application], params[:item][:discount], params[:item][:price])

                  if result == "ok"#商品がオタマート 側で編集された時だけ、updateする
                      @item.update(item_update_params)
                      @item.update(image1:image1, image2:image2,image3:image3,image4:image4)
                  end
                  redirect_to item_path(@item)
              else
                  logger.debug "#{Time.now - @account.access_time}"
                  logger.debug '#######no###########'
                  render "edit", status: :unprocessable_entity
              end
    end

    def destroy
        @item = Item.find(params[:id])
        @account = @item.account
        @item.destroy
        redirect_to account_path(@account)
    end


    def destroy_multi
        @account = Account.find(params[:account_id])
        @ota = Otamart_delete.new
        driver = @ota.login(@account.account_email,@account.account_password)
        if params[:items_destroy].blank? #全て選択すると、["1,2,3,4,5"]のような配列になりうまくいかない。["1","2","3","4","5"]のようにするために以下の処理。controllerのparamsを変えてる。アドホックな対応のため要変更
            checked_data =  params[:items_destroy_all].keys[0].split(", ")
        else
            checked_data = params[:items_destroy].keys
        end
        result = @ota.otamart_item_delete(driver, checked_data)
        redirect_to account_items_path
    end

    def exhibit
        @item = Item.find(params[:id])
        @account = @item.account
        if Time.now - @account.access_time > 30
            @account.access_time =  Time.now#ここで出品中は常に時間を更新することで、2回目に送られてくるリクエストが、Time.now - @account.access_time > 60にtrueにならないようにする
            @account.save
            @ota = Otamart.new
            logger.debug '#######1############'
            driver = @ota.login(@account.account_email,@account.account_password)
            logger.debug '#######2############'
            file_abs_path = Rails.root.join('public/zip_store', @item.csv.to_s + "/exhibit/")
            url = @ota.exhibit(driver,file_abs_path,@item.image1,@item.image2,@item.image3,@item.image4,@item.item_name,
                @item.description,@item.category1,@item.category2,@item.category3,@item.tags,@item.state,@item.ship_fee,
                @item.ship_method,@item.ship_from,@item.ship_day,@item.purchase_application,@item.discount,@item.price)
                logger.debug '#######3############'
            @item.url = url
            @item.save
        end
        redirect_to item_path(@item)
    end

    def re_exhibit
    end

    def exec_re_exhibit
        @account = Account.find(params[:account_id])
        method = params[:re_exhibit]
        if method == "1"
            @items = @account.random_exhibit ? @account.items.where.not(url:nil).order("RANDOM()") : @account.items.where.not(url:nil)
        else
            @items = @account.random_exhibit ? @account.items.where.not(url:nil).where(count_comments: 0).order("RANDOM()") : @account.items.where.not(url:nil).where(count_comments: 0)
        end
        @ota = OtamartReExhibit.new
        driver = @ota.login(@account.account_email,@account.account_password)
        @ota.re_exhibit(driver, @account, @items)
        redirect_to account_re_exhibit_path
    end

    private
      def item_params
        params.require(:item).permit(:csv)
      end

      def item_update_params
        params.require(:item).permit(:image1,:image2,:image3,:image4,:item_name,:description,:category1,:category2,:category3,:tags,:state,:ship_fee,:ship_method,:ship_from,:ship_day,:purchase_application,:discount,:price,:url)
      end

      def current_user_check
          @item = Item.find(params[:id])
          @account = @item.account
          if  @account.user_id != current_user.id
              redirect_to new_user_session_path
          end
      end

end
