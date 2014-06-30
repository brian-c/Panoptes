require 'spec_helper'

describe Api::V1::ClassificationsController, type: :controller do
  let!(:workflow) { create(:workflow_with_subjects) }
  let!(:set_member_subject) { workflow.subject_sets.first.set_member_subjects.first }
  let!(:user) { create(:user, cellect_hosts: { workflow.id.to_s => 'http://example.com' }) }

  context "logged in user" do
    before(:each) do
      default_request user_id: user.id, scopes: ["classifications"]
    end

    describe "#create" do
      def send_request
        params = {workflow_id: workflow.id,
                  subject_id: set_member_subject.id,
                  annotations: []}
        post :create, params, {'CONTENT_TYPE' => 'applicaiton/json' }
      end

      before(:each) do
        allow(Cellect::Client.connection).to receive(:add_seen)
        send_request
      end

      it "should return 204" do
        expect(response.status).to eq(204)
      end

      it "should send the add seen command to cellect" do
        expect(Cellect::Client.connection).to receive(:add_seen).with(
          set_member_subject.id.to_s,
          workflow_id: workflow.id.to_s,
          user_id: user.id,
          host: user.cellect_hosts[workflow.id.to_s]
        )
        send_request
      end
    end
  end
end
