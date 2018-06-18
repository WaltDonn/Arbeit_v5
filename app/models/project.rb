class Project < ApplicationRecord
  include ArbeitHelpers

  # Relationships
  has_many :tasks
  has_many :assignments
  has_many :users, through: :assignments
  belongs_to :domain
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'

  # allow tasks to be nested within project
  accepts_nested_attributes_for :tasks, reject_if: ->(task) { task[:name].blank? }, allow_destroy: true

  # Delegations
  delegate :name, to: :domain, prefix: true
  delegate :name, to: :manager, prefix: true
  delegate :proper_name, to: :manager, prefix: true

  # Scopes
  scope :alphabetical, -> { order("name") }
  scope :current,      -> { where("start_date <= ? and (end_date > ? or end_date is null)", Date.today, Date.today) }
  scope :past,         -> { where("end_date <= ?", Date.today) }
  scope :for_name,     ->(name) { where("name LIKE ?", name + "%") }
  scope :search,        ->(term) { find_by_sql(["SELECT * FROM projects WHERE name LIKE ?", "#{term}%"]) }

  # Validations
  validates_presence_of :name
  validates_date :start_date
  validates_date :end_date, after: :start_date, allow_blank: true
  validate :domain_is_active_in_system

  # Callbacks
  before_destroy do
    check_is_destroyable
    if errors.present?
      @destroyable = false
      throw(:abort)
    else
      end_project_now
    end
  end
  # after_rollback :end_project_now

  def end_project_now
    # return true unless !@destroyable
    remove_incomplete_tasks
    set_all_assignments_to_inactive
    set_project_end_date_to_today
  end

  # Other methods
  def is_active?
    return true if end_date.nil?
    (start_date <= Date.today) && (end_date > Date.today)
  end

  def no_completed_tasks?
    self.tasks.completed.empty?
  end

  private

  def check_is_destroyable
    unless no_completed_tasks?
      errors.add(:base, "Project cannot be deleted as it has completed tasks associated with it.")
    end
  end

  def domain_is_active_in_system
    is_active_in_system(:domain)
  end

  def remove_incomplete_tasks
    self.tasks.incomplete.each{ |t| t.delete }
  end

  def set_all_assignments_to_inactive
    self.assignments.active.each{ |a| a.make_inactive }
  end

  def set_project_end_date_to_today
    self.end_date = Date.today
    self.save!
  end
end
