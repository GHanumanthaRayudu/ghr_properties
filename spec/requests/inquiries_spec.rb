require 'rails_helper'

RSpec.describe "Inquiries", type: :request do
  let(:developer) { create(:user, role: :developer) }
  let(:customer) { create(:user, role: :customer) }
  let(:property) { create(:property, user: developer) }

  describe "POST /properties/:property_id/inquiries" do
    context "when user is a customer" do
      before { sign_in customer }

      it "creates a new inquiry" do
        expect {
          post property_inquiries_path(property), params: {
            inquiry: { message: "I am interested in this property" }
          }
        }.to change(Inquiry, :count).by(1)
      end

      it "redirects to the property page with success notice" do
        post property_inquiries_path(property), params: {
          inquiry: { message: "I am interested in this property" }
        }
        expect(response).to redirect_to(property)
        expect(flash[:notice]).to match(/submitted successfully/)
      end
    end

    context "when user is not a customer" do
      before { sign_in developer }

      it "does not create an inquiry" do
        expect {
          post property_inquiries_path(property), params: {
            inquiry: { message: "I am interested in this property" }
          }
        }.not_to change(Inquiry, :count)
      end

      it "redirects with an error message" do
        post property_inquiries_path(property), params: {
          inquiry: { message: "I am interested in this property" }
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/Only customers can submit inquiries/)
      end
    end

    context "when user is not logged in" do
      it "redirects to sign in page" do
        post property_inquiries_path(property), params: {
          inquiry: { message: "I am interested in this property" }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /properties/:property_id/inquiries" do
    let!(:inquiry) { create(:inquiry, property: property, customer: customer) }

    context "when property owner is viewing" do
      before { sign_in developer }

      it "shows all inquiries for the property" do
        get property_inquiries_path(property)
        expect(response).to have_http_status(:success)
      end
    end

    context "when non-owner tries to view" do
      before { sign_in customer }

      it "redirects with error" do
        get property_inquiries_path(property)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "PATCH /inquiries/:id" do
    let!(:inquiry) { create(:inquiry, property: property, customer: customer) }

    context "when property owner updates status" do
      before { sign_in developer }

      it "updates the inquiry status" do
        patch inquiry_path(inquiry), params: {
          inquiry: { status: :responded }
        }
        expect(inquiry.reload.status).to eq('responded')
      end

      it "redirects with success notice" do
        patch inquiry_path(inquiry), params: {
          inquiry: { status: :responded }
        }
        expect(response).to redirect_to(property_inquiries_path(property))
        expect(flash[:notice]).to match(/updated successfully/)
      end
    end

    context "when non-owner tries to update" do
      let(:other_user) { create(:user, role: :agent) }
      before { sign_in other_user }

      it "redirects with error" do
        patch inquiry_path(inquiry), params: {
          inquiry: { status: :responded }
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "GET /inquiries/:id" do
    let!(:inquiry) { create(:inquiry, property: property, customer: customer) }

    context "when customer views their own inquiry" do
      before { sign_in customer }

      it "shows the inquiry" do
        get inquiry_path(inquiry)
        expect(response).to have_http_status(:success)
      end
    end

    context "when property owner views the inquiry" do
      before { sign_in developer }

      it "shows the inquiry" do
        get inquiry_path(inquiry)
        expect(response).to have_http_status(:success)
      end
    end

    context "when unauthorized user tries to view" do
      let(:other_user) { create(:user, role: :customer) }
      before { sign_in other_user }

      it "redirects with error" do
        get inquiry_path(inquiry)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end
end


