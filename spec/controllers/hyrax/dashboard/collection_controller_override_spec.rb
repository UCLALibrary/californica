RSpec.describe Hyrax::Dashboard::CollectionsController, :clean_repo do
  routes { Hyrax::Engine.routes }
  let(:user)  { create(:user) }
  let(:other) { build(:user) }
  let(:collection_type_gid) { FactoryBot.create(:user_collection_type).to_global_id.to_s }

  let(:collection) do
    create(:public_collection_lw, title: ["My collection"],
                                  description: ["My incredibly detailed description of the collection"],
                                  user: user)
  end

  let(:asset1)         { create(:work, title: ["First of the Assets"], user: user) }
  let(:asset2)         { create(:work, title: ["Second of the Assets"], user: user) }
  let(:asset3)         { create(:work, title: ["Third of the Assets"], user: user) }
  let(:asset4)         { build(:collection_lw, title: ["First subcollection"], user: user) }
  let(:asset5)         { build(:collection_lw, title: ["Second subcollection"], user: user) }
  let(:unowned_asset)  { create(:work, user: other) }

  let(:collection_attrs) do
    { title: ['My First Collection'], description: ["The Description\r\n\r\nand more"], collection_type_gid: [collection_type_gid] }
  end

  describe "#update" do
    before { sign_in user }
    context "updating a collections metadata" do
      it "saves the metadata" do
        byebug
        put :update, params: { id: collection, collection: { creator: ['Emily'] } }
        collection.reload
        expect(collection.creator).to eq ['Emily']
        expect(flash[:notice]).to eq "Collection was successfully updated."
      end

      it "removes blank strings from params before updating Collection metadata" do
        put :update, params: {
          id: collection,
          collection: {
            title: ["My Next Collection "],
            creator: [""]
          }
        }
        expect(assigns[:collection].title).to eq ["My Next Collection "]
        expect(assigns[:collection].creator).to eq []
      end
    end
  end  
end
