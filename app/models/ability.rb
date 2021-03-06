class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :voteup, :votedown, :votedel, to: :vote

    @user = user
    if @user
      user_abilities
    else
      guest_abilities
    end
  end

  private

  def user_abilities
    can :create, [Question, Answer, Comment, Attachment, Subscription]
    api_abilities
    guest_abilities
    owner_abilities
    voting_abilities
  end

  def owner_abilities
    can [:update, :destroy], [Question, Answer, Comment, Subscription], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id }
    can :make_best, Answer, question: { user_id: @user.id }
    can :answer_best, Answer do |answer|
      @user.check_owner(answer.question)
    end
  end

  def guest_abilities
    can :read, :all
    cannot :read, User
  end

  def voting_abilities
    can :vote, [Question, Answer] do |votable|
      !@user.check_owner(votable)
    end
  end

  def api_abilities
    can [:me, :list], User
  end
end
