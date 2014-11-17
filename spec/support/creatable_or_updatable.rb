RSpec.shared_examples "creatable or updatable" do
  context "when a user doesn't a preference object for a project" do
    it_behaves_like "is creatable"
  end

  context "when a user has a preference object for a project" do
    let(:create_params) { created_params }
    
    context "when the resource has no set roles" do
      let!(:resource) { resource_to_update }
      
      it_behaves_like "is creatable"
    end

    context "when the resource has previously set roles" do
      let!(:resource) { resource_to_not_update }
      
      before(:each) do
        resource.roles = ["collaborator"]
        resource.save!
        default_request scopes: scopes, user_id: authorized_user.id
        post :create, create_params
      end

      it 'should return 422' do
        expect(response.status).to eq(422)
      end

      it 'should give an error explaination' do
        expect(json_response['errors'][0]['message'])
          .to eq("Cannot create roles resource when one exists for the user and project")
      end
    end
  end
end
