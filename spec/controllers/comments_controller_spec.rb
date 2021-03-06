require 'spec_helper'

describe CommentsController do

  before :all do
    @user = create(:user)
  end

  after :all do
    @user.destroy
  end

  describe "POST #create" do
    before :each do
      @publication = create(:publication, creator: @user)
    end

    describe "with format HTML" do
      describe "when authenticated" do
        before :each do
          sign_in @user
        end

        context "with valid attributes" do
          it "saves the new comment in the database" do
            expect{
              post :create, comment: attributes_for(:comment), publication_id: @publication
            }.to change(Comment, :count).by(1)
          end

          it "redirects to the timeline" do
            post :create, comment: attributes_for(:comment), publication_id: @publication
            response.should redirect_to timeline_index_path
          end

          it "flashes a success message" do
            post :create, comment: attributes_for(:comment), publication_id: @publication
            flash[:notice].should eq "Comment was successfully created!"
          end
        end

        context "with invalid attributes" do
          it "does not save the new comment in the database" do
            expect{
              post :create, comment: attributes_for(:invalid_comment), publication_id: @publication
            }.to_not change(Comment, :count)
          end

          it "redirects the timeline index template" do
            post :create, comment: attributes_for(:invalid_comment), publication_id: @publication
            response.should redirect_to timeline_index_path
          end

          it "returns error notice message" do
            post :create, comment: attributes_for(:invalid_comment), publication_id: @publication
            flash[:notice].should_not be_nil 
          end
        end
      end # describe "when authenticated"

      describe "when not authenticated" do
        it "it wont allow the operation" do
          post :create, comment: attributes_for(:comment), publication_id: @publication
          response.should redirect_to new_user_session_path
        end
      end
    end # describe "with format HTML"

    describe "with AJAX" do
      describe "when authenticated" do
        before :each do
          sign_in @user
        end

        context "with valid attributes" do
          it "saves the new comment in the database" do
            expect{
              xhr :post, :create, comment: attributes_for(:comment), publication_id: @publication
            }.to change(Comment, :count).by(1)
          end

          it "response should be 200" do
            xhr :post, :create, comment: attributes_for(:comment), publication_id: @publication
            response.should be_success
          end
        end

        context "with invalid attributes" do
          it "does not save the new comment in the database" do
            expect{
              xhr :post, :create, comment: attributes_for(:invalid_comment), publication_id: @publication
            }.to_not change(Comment, :count)
          end
        end
      end # describe "when authenticated"

      describe "when not authenticated" do
        it "it wont allow the operation" do
          xhr :post, :create, comment: attributes_for(:comment), publication_id: @publication
          response.status.should be(401)
        end
      end
    end # describe "with AJAX"
  end # describe "POST #create"

  describe "DELETE #destroy" do
    before :each do
      @publication = create(:publication, creator: @user)
      @comment = create(:comment, creator: @user, publication: @publication)
    end

    describe "with AJAX" do
      describe "when authenticated" do
        before :each do
          sign_in @user
        end

        it "deletes the requested comment" do
          expect{
            xhr :delete, :destroy, id: @comment, publication_id: @publication.id
          }.to change(Comment, :count).by(-1)
        end

        it "response should be success" do
          xhr :delete, :destroy, id: @comment, publication_id: @publication.id
          response.should be_success
        end

        describe "when the comment does not bellong to the user" do
          it "it wont allow the operation" do
            other_comment = create(:comment, publication: @publication)
            xhr :delete, :destroy, id: other_comment, publication_id: @publication.id
            response.status.should be(403)
          end
        end
      end # describe "when authenticated"

      describe "when not authenticated" do
        it "it wont allow the operation" do
          xhr :delete, :destroy, id: @comment, publication_id: @publication.id
          response.status.should be(401)
        end
      end
    end # describe "with AJAX"

    describe "format HTML" do
      describe "when authenticated" do
        before :each do
          sign_in @user
        end

        it "deletes the requested comment" do
          expect{
            delete :destroy, id: @comment, publication_id: @publication.id
          }.to change(Comment, :count).by(-1)
        end

        it "redirects to the timeline page" do
          delete :destroy, id: @comment, publication_id: @publication.id
          response.should redirect_to timeline_index_path
        end

        it "flashes a success message" do
          delete :destroy, id: @comment, publication_id: @publication.id
          flash[:notice].should eq "The comment was deleted successfully!"
        end

        describe "when the comment does not bellong to the user" do
          it "it wont allow the operation" do
            other_comment = create(:comment, publication: @publication)
            delete :destroy, id: other_comment, publication_id: @publication.id
            response.status.should be(403)
          end
        end
      end # describe "when authenticated"

      describe "when not authenticated" do
        it "it wont allow the operation" do
          delete :destroy, id: @comment, publication_id: @publication.id
          response.should redirect_to new_user_session_path
        end
      end
    end # describe "with format HTML"
  end # describe "DELETE #destroy"
end
