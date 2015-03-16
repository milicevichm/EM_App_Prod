class StaticPagesController < ApplicationController
  def home
    exec('python interpreter.py')
  end

  def about
  end
end
