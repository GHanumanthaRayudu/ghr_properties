require 'rails_helper'

RSpec.describe "Properties", type: :request do
  let(:developer) { create(:user, role: :developer) }
  let(:agent) { create(:user, role: :agent) }
  let(:customer) { create(:user, role: :customer) }
  let(:property) { create(:property, user: developer) }

  describe "GET /properties" do
    let!(:property1) { create(:property, user: developer, status: :available, city: 'Mumbai') }
    let!(:property2) { create(:property, user: agent, status: :sold, city: 'Delhi') }

    it "lists all properties" do
      get properties_path
      expect(response).to have_http_status(:success)
    end

    it "filters by status" do
      get properties_path, params: { status: 'available' }
      expect(response).to have_http_status(:success)
    end

    it "filters by location" do
      get properties_path, params: { location: 'Mumbai' }
      expect(response).to have_http_status(:success)
    end

    it "filters by price range" do
      get properties_path, params: { min_price: 1000000, max_price: 10000000 }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /properties/:id" do
    it "shows a property" do
      get property_path(property)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /properties/new" do
    context "when user is a developer" do
      before { sign_in developer }

      it "shows the new property form" do
        get new_property_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is an agent" do
      before { sign_in agent }

      it "shows the new property form" do
        get new_property_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is a customer" do
      before { sign_in customer }

      it "redirects with error" do
        get new_property_path
        expect(response).to redirect_to(properties_path)
        expect(flash[:alert]).to match(/Only developers and agents/)
      end
    end
  end

  describe "POST /properties" do
    let(:valid_attributes) do
      {
        title: "New Property",
        description: "A beautiful new property",
        property_type: :apartment,
        status: :available,
        price: 5000000,
        bedrooms: 3,
        bathrooms: 2,
        area: 1200,
        city: "Mumbai",
        state: "Maharashtra",
        address: "123 Main St",
        zip_code: "400001"
      }
    end

    context "when user is a developer" do
      before { sign_in developer }

      it "creates a new property" do
        expect {
          post properties_path, params: { property: valid_attributes }
        }.to change(Property, :count).by(1)
      end

      it "redirects to the new property" do
        post properties_path, params: { property: valid_attributes }
        expect(response).to redirect_to(Property.last)
        expect(flash[:notice]).to match(/successfully created/)
      end
    end

    context "when user is a customer" do
      before { sign_in customer }

      it "does not create a property" do
        expect {
          post properties_path, params: { property: valid_attributes }
        }.not_to change(Property, :count)
      end

      it "redirects with error" do
        post properties_path, params: { property: valid_attributes }
        expect(response).to redirect_to(properties_path)
        expect(flash[:alert]).to match(/Only developers and agents/)
      end
    end
  end

  describe "PATCH /properties/:id" do
    let(:property) { create(:property, user: developer) }
    let(:new_attributes) { { title: "Updated Title", status: :sold } }

    context "when property owner updates" do
      before { sign_in developer }

      it "updates the property" do
        patch property_path(property), params: { property: new_attributes }
        property.reload
        expect(property.title).to eq("Updated Title")
        expect(property.status).to eq("sold")
      end

      it "redirects to the property" do
        patch property_path(property), params: { property: new_attributes }
        expect(response).to redirect_to(property)
        expect(flash[:notice]).to match(/successfully updated/)
      end
    end

    context "when non-owner tries to update" do
      before { sign_in agent }

      it "redirects with error" do
        patch property_path(property), params: { property: new_attributes }
        expect(response).to redirect_to(properties_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "DELETE /properties/:id" do
    let!(:property) { create(:property, user: developer) }

    context "when property owner deletes" do
      before { sign_in developer }

      it "destroys the property" do
        expect {
          delete property_path(property)
        }.to change(Property, :count).by(-1)
      end

      it "redirects to properties list" do
        delete property_path(property)
        expect(response).to redirect_to(properties_url)
        expect(flash[:notice]).to match(/successfully deleted/)
      end
    end

    context "when non-owner tries to delete" do
      before { sign_in customer }

      it "does not destroy the property" do
        expect {
          delete property_path(property)
        }.not_to change(Property, :count)
      end
    end
  end
end


