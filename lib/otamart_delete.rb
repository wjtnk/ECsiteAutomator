require 'selenium-webdriver'

class Otamart_delete
    def headless_chrome_options
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


    def otamart_item_delete(driver, checked_data)
        wait = Selenium::WebDriver::Wait.new(:timeout => 60)
        for id in  checked_data
            item = Item.find(id)
            sleep(2)
            wait.until {driver.find_element(:css, 'div.row.row').displayed?}
                for element in driver.find_elements(:css, 'div.row.row') do
                    begin
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
                        end
                    rescue
                    end
                    driver.execute_script("scrollTo(0, 0)")
                end
            Item.destroy(id)
        end
        driver.close
        driver.quit
    end

end
