class AccountsController < ApplicationController
    before_action :authenticate_user!
    before_action :current_user_check, only: [:show, :edit, :update, :destroy, :multi_exhibit]

    def index
        @accounts = current_user.accounts.all
    end

    def new
        max_account = current_user.max_account - 1
        if max_account >=current_user.accounts.size
          @account = current_user.accounts.new
        else
            redirect_to accounts_path
        end
    end

    def create
        @account = current_user.accounts.new(account_params)
        @account.access_time =  Time.now
        if @account.save
            redirect_to @account
          else
            render :new, status: :unprocessable_entity
          end
    end

    def show
        @account = Account.find(params[:id])
        @items = @account.items.all.reverse_order
    end

    def edit
        @account = Account.find(params[:id])
    end

    def update
        @account = Account.find(params[:id])
        if @account.update(account_params)
            @account.save
            redirect_to @account
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
      @account = Account.find(params[:id])
      @account.destroy
      redirect_to accounts_path
    end

    def multi_exhibit
        @account = Account.find(params[:id])
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
                           sleep(Random.new().rand(@account.min_interval.to_i...@account.max_interval.to_i))
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
        redirect_to account_path(@account)
    end

    def schedule
        @account = Account.find(params[:id])
    end

    def items_to_csv
      @account = Account.find(params[:id])
      @items = @account.items
    end

    private

    def account_params
        params.require(:account).permit(:account_email, :account_password,:start_time, :min_interval, :max_interval, :random_exhibit)
    end


    def current_user_check
        @account = Account.find(params[:id])
        if @account.user_id != current_user.id
            redirect_to new_user_session_path
        end
    end
end
