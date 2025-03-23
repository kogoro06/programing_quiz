class RankingsController < ApplicationController
  def index
    @most_solved_quizzes = get_most_solved_quizzes
    @engaged_users = set_engaged_users
  end
end
