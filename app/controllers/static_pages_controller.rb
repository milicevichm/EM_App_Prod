class StaticPagesController < ApplicationController
  def home
    RubyPython.start
  end

  def about
  end
end
