class ArticlesController < ApplicationController
  def index
    render html: "<h1>HI. This thing is on.</h1>".html_safe
  end
end
