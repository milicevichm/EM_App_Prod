class StaticPagesController < ApplicationController
  def home
    @mains_small = MAINS_CSV[3..10803]

  end

  def about
  end
end
