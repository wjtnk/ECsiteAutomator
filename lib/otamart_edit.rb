require 'selenium-webdriver'

class Otamart_edit
    def headless_chrome_options
      options = Selenium::WebDriver::Chrome::Options.new
      # options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-gpu')
      options.add_argument('--hide-scrollbars')
      options
    end

    def login(account_email,account_password,url)
         driver = Selenium::WebDriver.for :chrome, options: headless_chrome_options
         begin
              wait = Selenium::WebDriver::Wait.new(:timeout => 60)
              # driver.manage.window.maximize
              driver.manage.window.resize_to(1200, 833)
               driver.navigate.to "#{url}"
               #アドレス、パスワード 入力
               wait.until {driver.find_element(:name,'email').displayed?}
               driver.find_element(:name,'email').send_keys(account_email)
               wait.until {driver.find_element(:name,'password').displayed?}
               driver.find_element(:name,'password').send_keys(account_password)
               #ログインボタンクリック
               wait.until {driver.find_elements(:class,'signup-method-button')[2].displayed?}
               driver.find_elements(:class,'signup-method-button')[2].click
          rescue
              driver.close
              driver.quit
          end
      return driver
    end

    def exec_item_edit(driver,file_abs_path,image1,image2,image3,image4,item_name,description,category1,category2,category3,tags,state,ship_fee,ship_method,ship_from,ship_day,purchase_application,discount,price)
        begin
            wait = Selenium::WebDriver::Wait.new(:timeout => 60)
            select = Selenium::WebDriver::Support

            #まずは既存の画像を削除
            sleep(2)
              if  !image1.blank?
                    image_num = driver.find_elements(:css, 'div.picture div.delete.clickable').size
                    image_num.times do |i|
                        driver.find_element(:css, 'div.picture div.delete.clickable').click
                    end
                    #画像を選択
                    wait.until {driver.find_element(:css, 'div.file').displayed?}
                    driver.find_element(:css, 'div.file input').send_keys(file_abs_path + image1)
               end

              if !image2.blank?
                  wait.until {driver.find_element(:css, 'div.file').displayed?}
                  driver.find_element(:css, 'div.file input').send_keys(file_abs_path + image2)
              end

              if !image3.blank?
                  wait.until {driver.find_element(:css, 'div.file').displayed?}
                  driver.find_element(:css, 'div.file input').send_keys(file_abs_path + image3)
              end

              if !image4.blank?
                  wait.until {driver.find_element(:css, 'div.file').displayed?}
                  driver.find_element(:css, 'div.file input').send_keys(file_abs_path + image4)
              end

            #商品名
            wait.until {driver.find_element(:css, 'div.name input').displayed?}
            sleep(2)
            driver.find_element(:css, 'div.name input').clear
            sleep(2)
            driver.find_element(:css, 'div.name input').send_keys(item_name)
            #商品の説明
            wait.until {driver.find_element(:css, 'div.convined textarea').displayed?}
            driver.find_element(:css, 'div.convined textarea').clear
            sleep(2)
            driver.find_element(:css, 'div.convined textarea').send_keys(description)
            # #カテゴリー
            wait.until {driver.find_element(:css, 'div.first-level').displayed?}
            select::Select.new(driver.find_element(:css, 'div.first-level select')).select_by(:value, category1.to_s)
            wait.until {driver.find_element(:css, 'div.second-level').displayed?}
            select::Select.new(driver.find_element(:css, 'div.second-level select')).select_by(:value, category2.to_s)
            if !category3.blank?
                wait.until {driver.find_element(:css, 'div.third-level').displayed?}
                select::Select.new(driver.find_element(:css, 'div.third-level select')).select_by(:value, category3.to_s)
            end

            #タグ追加(全角のコロンがあったら半角にしてsplit)
            tag_num = driver.find_elements(:css, 'div.tag div.delete').size #現在のtag削除
            tag_num.times do |t|
                driver.find_elements(:css, 'div.tag div.delete')[0].click
            end

            tags = tags.gsub("：",":").split(":")
            tags.each do |tag|
                wait.until {driver.find_element(:css, 'div.tags-input input').displayed?}
                driver.find_element(:css, 'div.tags-input input').send_keys(tag)
                wait.until {driver.find_element(:css, 'div.tags-input button').displayed?}
                driver.find_element(:css, 'div.tags-input button').send_keys(:enter)
            end

            #商品の状態
            wait.until {driver.find_elements(:css, 'div.info div.info-value')[0].displayed?}
            select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[0]).select_by(:value, state.to_s)

            #送料の表示
            wait.until {driver.find_element(:css, 'div.info div.info-value').displayed?}
            driver.find_element(:css, 'div.info-value.clickable').click
            sleep(2)
            if ship_fee.to_s == "0"
                wait.until {driver.find_elements(:css, 'div.clickable')[2].displayed?}
                driver.find_elements(:css, 'div.clickable')[2].click
            elsif ship_fee.to_s == "1"
                wait.until {driver.find_elements(:css, 'div.clickable')[3].displayed?}
                driver.find_elements(:css, 'div.clickable')[3].click
            else
                wait.until {driver.find_elements(:css, 'div.clickable')[4].displayed?}
                driver.find_elements(:css, 'div.clickable')[4].click
            end

            #配送方法
            wait.until {driver.find_elements(:css, 'div.info div.info-value')[1].displayed?}
            select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[1]).select_by(:value, ship_method.to_s)
            #発送元の地域
            wait.until {driver.find_elements(:css, 'div.info div.info-value')[2].displayed?}
            select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[2]).select_by(:value, ship_from.to_s)
            #発送日の目安　
            wait.until {driver.find_elements(:css, 'div.info div.info-value')[3].displayed?}
            select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[3]).select_by(:value, ship_day.to_s)
            # #購入申込みの承諾
            wait.until {driver.find_element(:css, 'div.accept-buy-request').displayed?}
            driver.find_element(:css, 'div.accept-buy-request').click
            if purchase_application == 0
                wait.until {driver.find_elements(:css, 'div.clickable')[1].displayed?}
                driver.find_elements(:css, 'div.clickable')[1].click
            else
                wait.until {driver.find_elements(:css, 'div.clickable')[2].displayed?}
                driver.find_elements(:css, 'div.clickable')[2].click
            end
            #
            #「値下げしません」を表示する
            if discount == true
                wait.until {driver.find_element(:css, 'div.cannot_negotiate svg').displayed?}
                driver.find_element(:css, 'div.cannot_negotiate svg').click
            end
            # #販売価格
            wait.until {driver.find_element(:css, 'div.price input').displayed?}
            driver.find_element(:css, 'div.price input').clear
            driver.find_element(:css, 'div.price input').send_keys(price)

            #「出品する」ボタン
            sleep(2)
            wait.until {driver.find_element(:css, 'button.primary-button').displayed?}
            driver.find_element(:css, 'button.primary-button').click
            wait.until {driver.find_element(:css, 'button.ok').displayed?}
            driver.find_element(:css, 'button.ok').click
            sleep(2)
            wait.until {driver.find_element(:css, 'button.ok').displayed?}
            driver.find_element(:css, 'button.ok').click
            driver.close
            driver.quit
            return "ok"
        rescue
            driver.close
            driver.quit
        end
    end

    def item_edit(driver,file_abs_path,image1,image2,image3,image4,item_name,description,category1,category2,category3,tags,state,ship_fee,ship_method,ship_from,ship_day,purchase_application,discount,price)
        result = exec_item_edit(driver,file_abs_path,image1,image2,image3,image4,item_name,description,category1,category2,category3,tags,state,ship_fee,ship_method,ship_from,ship_day,purchase_application,discount,price)
        return result
    end

end
