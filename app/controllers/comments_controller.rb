class CommentsController < ApplicationController

    def create
      @item = Item.find(params[:item_id])
      @comment = @item.comments.new(comment_params)
      count,name = post_comment(@item.account.account_email, @item.account.account_password, @item.url, @comment.content)#コメント数（出品者が投稿した後は必ずコメントが１増えている）
      @comment.name = name
      @item.count_comments = count
      @item.new_comment = false#コメントしたという事は、相手の投稿もチェックしているという事なので、「新着コメント無し」にする
      @item.save
      @comment.save
      redirect_to item_path(@item)
    end

    def get_comment
        @item = Item.find(params[:id])
        @account = @item.account
        @comments = @item.comments
        @ota = Otamart.new
        driver = @ota.login(@account.account_email,@account.account_password)
        array = @ota.get_comment(driver, @item.url)
        #コメントが更新されていたときだけ保存
        if @item.count_comments < array.size
            @item.count_comments = array.size
            @item.new_comment = true
            @item.save
            num = @item.count_comments - @comments.size#@comments.sizeは更新される前のコメント数
                array[-num..-1].each do |a| #新規のコメント以降を登録
                    @comment = @item.comments.new
                    @comment.name = a[:name]
                    @comment.content = a[:content]
                    @comment.save
                end
        end
        redirect_to item_path(@item)
     end


    def get_multi_comment
        @account = Account.find(params[:id])
        @ota = Otamart.new
        driver = @ota.login(@account.account_email,@account.account_password)
        for item in @account.items do
            if !item.url.blank?
                @comments = item.comments#更新される前のコメント
                array = @ota.get_multi_comment(driver, item.url)
                #コメントが更新されていたときだけ保存
                if item.count_comments < array.size #item.count_commentsは更新される前のコメント数
                    item.count_comments = array.size#item.count_commentsが更新された
                    item.new_comment = true
                    item.save
                    num = item.count_comments - @comments.size #更新される前のコメント数ー更新されたのコメント数ー
                        array[-num..-1].each do |a| #新規のコメント以降を登録
                            @comment = item.comments.new
                            @comment.name = a[:name]
                            @comment.content = a[:content]
                            @comment.save
                        end
                end
            end
        end
        driver.close
        driver.quit
    end


    def post_comment(account_email, account_password, url, content)
        @ota = Otamart.new
        driver = @ota.login(account_email, account_password)
        count,name = @ota.post_comment(driver, url,content)
        return count,name
    end

    private
      def comment_params
        params.require(:comment).permit(:name, :content)
      end
end
