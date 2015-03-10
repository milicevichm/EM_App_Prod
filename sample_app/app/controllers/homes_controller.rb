class HomesController < ApplicationController
  def show
    @visits = Visit.all
  end
end
