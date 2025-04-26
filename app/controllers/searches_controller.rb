class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @how = params[:how]

    if @range == "User"
      @users = User.search_for(@word, @how)
    else
      @books = Book.search_for(@word, @how)
    end
  end
end
