require "spec_helper"

RSpec.describe SubjectQueueWorker do
  subject { described_class.new }
  let(:workflow) { create(:workflow_with_subject_set) }
  let!(:subjects) do
    create_list(:set_member_subject, 100, subject_set: workflow.subject_sets.first)
  end

  describe "#perform" do
    context "with no user or set" do
      it 'should create a subject queue with the default number of items' do
        subject.perform(workflow.id)
        queue = SubjectQueue.find_by(workflow: workflow)
        expect(queue.set_member_subject_ids.length).to eq(100)
      end
    end

    context "when a workflow id string is passed in", :inline do
      it "should not raise an error" do
        expect{subject.perform(workflow.id.to_s)}.to_not raise_error
      end
    end
  end
end
