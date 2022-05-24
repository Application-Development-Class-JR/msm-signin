class BookmarksController < ApplicationController

  #before_action(:load_current_user)

  #def load_current_user
    #@current_user = User.where({ :id => session[:user_id] }).at(0)
  #end

  def index
    #aqui embaixo sem a personaliaçao estava  matching_bookmarks = Bookmark.all, ai mudamos para só mostrar os bookmarks da própria pessoa que está logada
    #matching_bookmarks = Bookmark.where({ :user_id => session.fetch(:user_id)})
    #outra opçao mais sofisticada
    #no inicio ou vc repete o @current_user = User.where({ :id => session[:user_id] }).at(0) --> em todas as açoes, ou vc criar o load_currente_user ali no inicio e colocar self.load_currente_user em todas...
    #self.load_currente_user
    #se usar o before_action não precisa replicar o self em todas as açoes para ficar mais conciso ainda, se quiser replicar as 2 acoes iniciais para personalizacao de página em todos os controller é só colar essas açoes no Application Controller

    matching_bookmarks =  @current_user.bookmarks

    @list_of_bookmarks = matching_bookmarks.order({ :created_at => :desc })

    render({ :template => "bookmarks/index.html.erb" })
  end

  def show
    #self.load_currente_user
    
    the_id = params.fetch("path_id")

    matching_bookmarks = Bookmark.where({ :id => the_id })

    @the_bookmark = matching_bookmarks.at(0)

    render({ :template => "bookmarks/show.html.erb" })
  end

  def create
    #self.load_currente_user

    the_bookmark = Bookmark.new
    the_bookmark.user_id = @current_user.id
    the_bookmark.movie_id = params.fetch("query_movie_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks", { :notice => "Bookmark created successfully." })
    else
      redirect_to("/bookmarks", { :alert => the_bookmark.errors.full_messages.to_sentence })
    end
  end

  def update
    #self.load_currente_user

    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.user_id = params.fetch("query_user_id")
    the_bookmark.movie_id = params.fetch("query_movie_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks/#{the_bookmark.id}", { :notice => "Bookmark updated successfully."} )
    else
      redirect_to("/bookmarks/#{the_bookmark.id}", { :alert => the_bookmark.errors.full_messages.to_sentence })
    end
  end

  def destroy
    
    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.destroy

    redirect_to("/bookmarks", { :notice => "Bookmark deleted successfully."} )
  end
end
