class PublicationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js
  
  def index
    @publications = nil
    unless params[:tags_ids].nil?
      @publications = Publication.includes(:tags).where({'tags.id' => params[:tags_ids]})
    else
      @publications = Publication.all
    end
  end

  def show
    @publication = Publication.find(params[:id])
  end

  def new
    @publication = Publication.new
  end

  def create
    @new_publication = Publication.new(publication_params)
    @new_publication.tags = Tag.find(params[:publication][:tags]) unless params[:publication][:tags].nil?
    @new_publication.creator = current_user

    if params[:publication][:organization_id].nil? or params[:publication][:organization_id] == "0"
      @new_publication.organization = nil
    else
      @new_publication.organization = Organization.find(params[:publication][:organization_id])
    end

    if @new_publication.save
      redirect_to timeline_index_path, notice: "Publication successfully created."
    else
      @publications=Publication.paginate(page: params[:publications_page],per_page: 100).order('created_at DESC')
      @publications.each do |p|
        p.paginated_comments = p.comments.includes(:creator).paginate(page: 1, per_page: 10).order('updated_at DESC')
      end
      @events=Event.paginate(page: params[:events_page],per_page: 100).order('date_start DESC')
      @new_event = Event.new  
      render '/timeline/index'
    end
  end

  def edit
    @publication = Publication.find(params[:id])
    return head :forbidden unless @publication.creator.id == current_user.id
  end

  def update
    @publication = Publication.find(params[:id])
    return head :forbidden unless @publication.creator.id == current_user.id
    @publication.update_attributes(publication_params)
    if @publication.update_attributes(publication_params)
      redirect_to @publication
    else
      render 'edit'
    end
  end

  def destroy
    @publication = Publication.find(params[:id])
    respond_to do |format|
      if @publication.creator == current_user
        @publication.destroy
        format.html { redirect_to '/', notice: 'The publication was deleted successfully!' }
        format.js   {}
      else
        return head :forbidden
      end
    end
  end

  def load

  end

  private 

  def publication_params
    params.require(:publication).permit(:text)
  end
end
