require 'selenium-webdriver'

class OtamartReExhibit
    def headless_chrome_options
      # options = Selenium::WebDriver::Chrome::Options.new(:port => 80)
      options = Selenium::WebDriver::Chrome::Options.new
      # options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-gpu')
      options.add_argument('--hide-scrollbars')
      options
    end

    def login(account_email,account_password)
         driver = Selenium::WebDriver.for :chrome, options: headless_chrome_options
         begin
              wait = Selenium::WebDriver::Wait.new(:timeout => 60)
              # driver.manage.window.maximize
              driver.manage.window.resize_to(1200, 833)
               driver.navigate.to "https://webapp.otamart.com/selling"
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

    def re_exhibit(driver, account, items)
        for item in items
            driver = otamart_item_delete(driver, item)
            driver = exec_re_exhibit(driver, item)
            sleep(Random.new().rand(account.min_interval.to_i..account.max_interval.to_i))
        end
        driver.close
        driver.quit
    end

    def otamart_item_delete(driver, item)
        sleep(2)
        driver.navigate.to "https://webapp.otamart.com/selling" #出品商品一覧
        wait = Selenium::WebDriver::Wait.new(:timeout => 60)
        wait.until {driver.find_element(:css, 'div.row.row').displayed?}
        for element in driver.find_elements(:css, 'div.row.row') do
            if element.find_element(:css, 'a.link.row-main').attribute("href") == "https://otamart.com/items/#{item.url.split('/')[-2]}"
                wait.until {element.find_element(:css, 'div.menu-button').displayed?}
                element.find_element(:css, 'div.menu-button').click
                wait.until {driver.find_element(:css, 'a.menu-link.caution').displayed?}
                driver.find_element(:css, 'a.menu-link.caution').click
                sleep(2)
                wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
                driver.find_element(:css, 'div.dialog button.ok').click
                sleep(2)
                wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
                driver.find_element(:css, 'div.dialog button.ok').click
                sleep(2)
                return driver
            end
        end
    end


  def exec_re_exhibit(driver, item)
      file_abs_path = Rails.root.join('public/zip_store', item.csv.to_s + "/exhibit/")
      begin
          wait = Selenium::WebDriver::Wait.new(:timeout => 60)
           driver.navigate.to "https://webapp.otamart.com/sell" #商品出品
          #ドロップダウンを操作するための準備
          select = Selenium::WebDriver::Support
          #画像を選択
          wait.until {driver.find_element(:css, 'div.file').displayed?}
          driver.find_element(:css, 'div.file input').send_keys(file_abs_path + item.image1)

            if !item.image2.blank?
                wait.until {driver.find_element(:css, 'div.file').displayed?}
                driver.find_element(:css, 'div.file input').send_keys(file_abs_path + item.image2)
            end
            if !item.image3.blank?
                wait.until {driver.find_element(:css, 'div.file').displayed?}
                driver.find_element(:css, 'div.file input').send_keys(file_abs_path + item.image3)
            end
            if !item.image4.blank?
                wait.until {driver.find_element(:css, 'div.file').displayed?}
                driver.find_element(:css, 'div.file input').send_keys(file_abs_path + item.image4)
            end

          #商品名
          wait.until {driver.find_element(:css, 'div.name input').displayed?}
          driver.find_element(:css, 'div.name input').send_keys(item.item_name)
          #商品の説明
          wait.until {driver.find_element(:css, 'div.convined textarea').displayed?}
          driver.find_element(:css, 'div.convined textarea').send_keys(item.description)
          #カテゴリー
          wait.until {driver.find_element(:css, 'div.first-level').displayed?}
          select::Select.new(driver.find_element(:css, 'div.first-level select')).select_by(:value, item.category1.to_s)
          wait.until {driver.find_element(:css, 'div.second-level').displayed?}
          select::Select.new(driver.find_element(:css, 'div.second-level select')).select_by(:value, item.category2.to_s)
          if !item.category3.blank?
              wait.until {driver.find_element(:css, 'div.third-level').displayed?}
              select::Select.new(driver.find_element(:css, 'div.third-level select')).select_by(:value, item.category3.to_s)
          end

          #タグ追加(全角のコロンがあったら半角にしてsplit)
          tags = item.tags.gsub("：",":").split(":")
          tags.each do |tag|
              wait.until {driver.find_element(:css, 'div.tags-input input').displayed?}
              driver.find_element(:css, 'div.tags-input input').send_keys(tag)
              wait.until {driver.find_element(:css, 'div.tags-input button').displayed?}
              driver.find_element(:css, 'div.tags-input button').send_keys(:enter)
          end

          #商品の状態
          wait.until {driver.find_elements(:css, 'div.info div.info-value')[0].displayed?}
          select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[0]).select_by(:value, item.state.to_s)
          #送料の表示
          wait.until {driver.find_element(:css, 'div.info div.please-select').displayed?}
          driver.find_element(:css, 'div.info div.please-select').click
          sleep(2)
          if item.ship_fee.to_s == "0"
              wait.until {driver.find_elements(:css, 'div.clickable')[2].displayed?}
              driver.find_elements(:css, 'div.clickable')[2].click
          elsif item.ship_fee.to_s == "1"
              wait.until {driver.find_elements(:css, 'div.clickable')[3].displayed?}
              driver.find_elements(:css, 'div.clickable')[3].click
          else
              wait.until {driver.find_elements(:css, 'div.clickable')[4].displayed?}
              driver.find_elements(:css, 'div.clickable')[4].click
          end
          #配送方法
          wait.until {driver.find_elements(:css, 'div.info div.info-value')[1].displayed?}
          select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[1]).select_by(:value, item.ship_method.to_s)
          #発送元の地域
          wait.until {driver.find_elements(:css, 'div.info div.info-value')[2].displayed?}
          select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[2]).select_by(:value, item.ship_from.to_s)
          #発送日の目安　
          wait.until {driver.find_elements(:css, 'div.info div.info-value')[3].displayed?}
          select::Select.new(driver.find_elements(:css, 'div.info div.info-value select')[3]).select_by(:value, item.ship_day.to_s)
          #購入申込みの承諾
          wait.until {driver.find_element(:css, 'div.accept-buy-request').displayed?}
          driver.find_element(:css, 'div.accept-buy-request').click
          if item.purchase_application == 0
              wait.until {driver.find_elements(:css, 'div.clickable')[1].displayed?}
              driver.find_elements(:css, 'div.clickable')[1].click
          else
              wait.until {driver.find_elements(:css, 'div.clickable')[2].displayed?}
              driver.find_elements(:css, 'div.clickable')[2].click
          end

          #「値下げしません」を表示する
          if item.discount == true
              wait.until {driver.find_element(:css, 'div.cannot_negotiate svg').displayed?}
              driver.find_element(:css, 'div.cannot_negotiate svg').click
          end

          #販売価格
          wait.until {driver.find_element(:css, 'div.price input').displayed?}
          driver.find_element(:css, 'div.price input').send_keys(item.price)
          #「出品する」ボタン
          sleep(2)
          wait.until {driver.find_element(:css, 'button.primary-button').displayed?}
          driver.find_element(:css, 'button.primary-button').click
          wait.until {driver.find_element(:css, 'button.ok').displayed?}
          driver.find_element(:css, 'button.ok').click
          sleep(2)
          wait.until {driver.find_element(:css, 'button.ok').displayed?}
          driver.find_element(:css, 'button.ok').click
          sleep(2)
          # url取得
          wait.until {driver.find_elements(:css, 'div.row a')[0].displayed?}
          new_url = driver.find_elements(:css, 'div.row a')[0].attribute('href').gsub(/[^\d]/, "")
          new_url  = "https://webapp.otamart.com/items/"+ new_url +"/comments"
          item.url = new_url
          item.save
      rescue
          driver.close
          driver.quit
      end
      return driver
  end

end
