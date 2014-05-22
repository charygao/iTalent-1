class TimelineController < ApplicationController

  before_filter :authenticate_user!

  def index

    @publications = Publication.includes(:creator).paginate(page: params[:page], per_page:5).order('created_at DESC')
    @publications.each do |p|
      p.paginated_comments = p.comments.includes(:creator).paginate(page: 1).order('updated_at ASC')
    end

    @events = Event.includes(:creator).paginate(page: params[:events_page],per_page:10).order('date_start DESC')
    @new_publication = Publication.new
    @new_event = Event.new
    @comment = Comment.new

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
end
