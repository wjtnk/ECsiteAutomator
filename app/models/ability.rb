class Ability
  include CanCan::Ability

  def initialize(user)
      #管理者権限
        if user && user.admin_flg? && user.user_flg?
             forbid(user)
        end
        #全てのユーザーがエクスポート出来るように
        if user && user.user_flg? && !user.admin_flg?
             forbid(user)
             cannot :manage, User
        end

   end

   def forbid(user)
       can :access, :rails_admin
       can :manage, :all
       cannot :manage, Account
       cannot :manage, Item
       cannot :manage, Comment
       #自分のaccountだけ表示
       can :manage, Account, user_id: user
       cannot [:create, :destroy], Account
       #自分のitemだけ表示
       user.accounts.each do |account|
          can :manage, Item, account_id: account.id
          cannot [:create, :destroy], Item
       end
       #自分のコメントだけ表示
       # user.accounts.each do |account|
       #     account.items.each do |item|
       #        can :manage, Comment, item_id: item.id
       #     end
       # end
   end


 end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
