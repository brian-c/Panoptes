class SubjectSet < ActiveRecord::Base
  include RoleControl::ParentalControlled
  include Linkable

  belongs_to :project
  has_and_belongs_to_many :workflows

  has_many :set_member_subjects
  has_many :subjects, through: :set_member_subjects

  validates_presence_of :project

  validates_uniqueness_of :display_name, scope: :project_id

  scope :expert_sets, -> { where(expert_set: true) }

  can_through_parent :project, :update, :show, :destroy, :index, :update_links,
    :destroy_links

  can_be_linked :workflow, :same_project?, :model
  can_be_linked :set_member_subject, :scope_for, :update, :user

  def self.same_project?(workflow)
    where(project: workflow.project)
  end

end
