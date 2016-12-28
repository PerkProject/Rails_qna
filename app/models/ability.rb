class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user
      user_abilities
    else
      guest_abilities
    end
  end

  private

  def user_abilities
    can :create, [Question, Answer, Comment, Attachment]
    guest_abilities
    owner_abilities
    voting_abilities
  end

  def owner_abilities
    can [:update, :destroy], [Question, Answer, Comment], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id }
    can :accept, Answer, question: { user_id: @user.id }
  end

  def guest_abilities
    can :read, :all
    cannot :read, User
  end

  def voting_abilities
    can [:voteup, :votedown], [Answer, Question] do |votable|
      votable.votes.find_by(user_id: @user.id).nil? && !@user.check_owner(votable)
    end
    can :votedel, [Answer, Question] do |votable|
      votable.votes.find_by(user_id: @user.id) && !@user.check_owner(votable)
    end
  end
end
