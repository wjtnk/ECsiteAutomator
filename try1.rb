require 'selenium-webdriver'
driver = Selenium::WebDriver.for :chrome
driver.navigate.to 'https://webapp.otamart.com/selling'
# driver.find_element(:css, 'div#my-menu a.login p').click
sleep(1)
driver.find_element(:name,'email').send_keys("Jtlnwuj@yahoo.co.jp")
driver.find_element(:name,'password').send_keys("svshior34")
driver.find_elements(:class,'signup-method-button')[2].click

wait = Selenium::WebDriver::Wait.new(:timeout => 60)
sleep(10)
# #全削除
# driver.find_elements(:css, 'div.row.row').size.times do
#     wait.until {driver.find_element(:css, 'div.menu-button').displayed?}
#     driver.find_element(:css, 'div.menu-button').click
#     wait.until {driver.find_element(:css, 'a.menu-link.caution').displayed?}
#     driver.find_element(:css, 'a.menu-link.caution').click
#     sleep(2)
#     wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#     driver.find_element(:css, 'div.dialog button.ok').click
#     sleep(2)
#     wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#     driver.find_element(:css, 'div.dialog button.ok').click
# end
#
# # 選択した商品だけ削除
# for element in driver.find_elements(:css, 'div.row.row') do
#     if element.find_element(:css, 'div.name').text == "ヒロアカ16巻"
#         wait.until {element.find_element(:css, 'div.menu-button').displayed?}
#         element.find_element(:css, 'div.menu-button').click
#
#         wait.until {driver.find_element(:css, 'a.menu-link.caution').displayed?}
#         driver.find_element(:css, 'a.menu-link.caution').click
#         sleep(2)
#         wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#         driver.find_element(:css, 'div.dialog button.ok').click
#         sleep(2)
#         wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#         driver.find_element(:css, 'div.dialog button.ok').click
#     end
# end





# driver.find_elements(:css, 'div.name').size.times do
#     if driver.find_elements(:css, 'div.name').text == "ヒロアカ12巻"
#         wait.until {driver.find_element(:css, 'div.menu-button').displayed?}
#         driver.find_element(:css, 'div.menu-button').click
#         wait.until {driver.find_element(:css, 'a.menu-link.caution').displayed?}
#         driver.find_element(:css, 'a.menu-link.caution').click
#         sleep(2)
#         wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#         driver.find_element(:css, 'div.dialog button.ok').click
#         sleep(2)
#         wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#         driver.find_element(:css, 'div.dialog button.ok').click
#     end
# end





# for element in driver.find_elements(:css, 'div.row.row')
#     wait.until {element.find_element(:css, 'div.menu-button').displayed?}
#     element.find_element(:css, 'div.menu-button').click
#     wait.until {element.find_element(:css, 'a.menu-link.caution').displayed?}
#     element.find_element(:css, 'a.menu-link.caution').click
#     sleep(2)
#     wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#     driver.find_element(:css, 'div.dialog button.ok').click
#     sleep(2)
#     wait.until {driver.find_element(:css, 'div.dialog button.ok').displayed?}
#     driver.find_element(:css, 'div.dialog button.ok').click
# end


















































#
# require "csv"
# large_ele =  driver.find_element(:css, 'div.category-select div.select-align-right select');
# large_select = Selenium::WebDriver::Support::Select.new(large_ele)
#
# la_array = []
# for i in 1..large_ele.find_elements(:css, 'option').size-1
#     large_select .select_by(:index, i)#大カテゴリ
#
#     midium_ele = driver.find_elements(:css, 'div.category-select div.select-align-right select')[1]
#     midium_select = Selenium::WebDriver::Support::Select.new(midium_ele)
#     for i in 1..midium_ele.find_elements(:css, 'option').size-1
#         midium_select.select_by(:index, i)#中カテゴリ
#         sleep(1)
#         array = []
#                 for ele in driver.find_elements(:css,"div.category-select div.select-align-right")
#                     for e in ele.find_elements(:css,"select option")
#                             if e.attribute("innerHTML") == driver.find_elements(:css,"div.overwrap div.label")[0].text
#                                 la = e.attribute("value") +":" + driver.find_elements(:css,"div.overwrap div.label")[0].text #大カテゴリ
#                                 # puts "L:" + e.attribute("value") + driver.find_elements(:css,"div.overwrap div.label")[0].text #大カテゴリ
#                                 array.push(la)
#                             end
#                             if e.attribute("innerHTML") == driver.find_elements(:css,"div.overwrap div.label")[1].text
#                                 md  = e.attribute("value") + ":" + driver.find_elements(:css,"div.overwrap div.label")[1].text #中カテゴリ
#                                 # puts "M:"+  e.attribute("value") + driver.find_elements(:css,"div.overwrap div.label")[1].text #中カテゴリ
#                                 array.push(md)
#                             end
#                     end
#                 end
#
#                 num =0
#                 for ele in driver.find_elements(:css,"div.category-select div.select-align-right")
#                      if num == 2
#                          # puts "------------------SMALL------------------"
#                         array_small = []
#                         for e in ele.find_elements(:css,"select option")
#                             if e.attribute("innerHTML") != "選択して下さい"
#                               sm =  "#{e.attribute("value")}:#{e.attribute("innerHTML")}"
#                               # puts "#{e.attribute("value")}:#{e.attribute("innerHTML")}"
#                               array_small.push(sm)
#                            end
#                         end
#                         array.push(array_small.join("\n"))
#                     end
#                      num += 1
#                 end
#         puts array
#         puts "############"
#         sleep(1)
#         la_array.push(array)
#     end
#
#     CSV.open('hoge1.csv','w') do |test|
#         la_array.each do |a|
#             test << a
#         end
#     end
# end
