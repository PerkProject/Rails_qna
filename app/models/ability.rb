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
    guest_abilites
    owner_abilities
  end

  def owner_abilities
    can [:update, :destroy], [Question, Answer, Comment], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id }
    can :accept, Answer, question: { user_id: @user.id }
  end

  def guest_abilites
    can :read, :all
    cannot :read, User
  end
end
