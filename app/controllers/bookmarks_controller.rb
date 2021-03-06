class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @topic = Topic.find(params[:topic_id])
    @bookmarks = current_user.topics.find(params[:topic_id]).bookmarks.all
    @bookmark = current_user.topics.find(params[:topic_id]).bookmarks.new
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    @notes = @bookmark.notes
  end

  # GET /bookmarks/new
  def new
    @topic = Topic.find(params[:topic_id])
    @bookmark = Bookmark.new
    @results = [["link an incredibly long and descriptive link name for a site", "urlareallyreallyreallylongurllongerthanthisevenis"], ["link", "url"], ["link", "url"], ["link", "url"]]
    # @results = []

    if params[:links] == "active"
      @results = GoogleService.new(@topic.name).load_pages
    end
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)
    @title = PageTitleGetter.new(params[:bookmark][:url]).title
    @bookmark.name = @title

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to topic_bookmarks_path, notice: 'Bookmark was successfully created.' }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to topic_bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = current_user.topics.find(params[:topic_id]).bookmarks.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params.require(:bookmark).permit(:name, :url, :topic_id)
    end
end
