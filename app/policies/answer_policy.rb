class AnswerPolicy < ApplicationPolicy
  def update?
    record.user == user
  end

  def create?
    true
  end

  def edit?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def answer_best?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
