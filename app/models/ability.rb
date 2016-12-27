class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user
      user_abilites
    else
      guest_abilites
    end
  end

  private

  def user_abilites
    can :create, [Question, Answer, Comment, Attachment]
  end

  def guest_abilites
    can :read, :all
  end
end
