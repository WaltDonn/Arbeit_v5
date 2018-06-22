class User < ApplicationRecord

  # Relationships
  # -----------------------------
  has_many :assignments
  has_many :projects, through: :assignments
  has_many :completed_tasks, class_name: 'Task', foreign_key: 'completed_by'
  has_many :created_tasks, class_name: 'Task', foreign_key: 'created_by'

  # Scopes
  # -----------------------------
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :search, ->(term) { where('first_name LIKE ? OR last_name LIKE ?', "#{term}%", "#{term}%") }

  # Validations
  # -----------------------------
  # make sure required fields are present

  validates :password, :presence => true, :confirmation => true, :length => {:within => 6..40}, :on => :create, :if => :password

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email, allow_blank: true
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([a-z0-9.-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: 'is not a valid format', allow_blank: true

  # Other methods
  # -----------------------------
  def proper_name
    first_name + ' ' + last_name
  end

  def name
    last_name + ', ' + first_name
  end

  # for use in authorizing with CanCan
  ROLES = [['Administrator', :admin], ['Member', :member]]

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  before_save :hash_password

  def self.authenticate(email, password)
   auth = nil
   user = find_by_email(email)
   if user
     if user.password == Base64.encode64(password).chomp
       auth = user
     else
        raise Exceptions::PasswordNotFound
     end
   else
      raise Exceptions::EmailDoesntExist
   end
   return auth
  end

  def hash_password
    if password.present?
      self.password = Base64.encode64(password).chomp
    end
  end

end
