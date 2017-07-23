# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Space < ApplicationRecord
  belongs_to :user
  has_many :projects

  validates_uniqueness_of :name, scope: [:user_id], message: 'You have a space with this name'
  validates :name, presence: true, length: { maximum: 25 }
  validates :name, exclusion: { in: %w(create setting spaces chart),
                                message: '%{value} is reserved.' }

  before_validation :name_format

  scope :count_by_user, -> user_id {
          where('user_id = ?', user_id).count
        }

  scope :find_by_user_order, -> user_id {
          where('user_id = ?', user_id).
          order(created_at: :desc)
        }

  scope :find_by_user_and_name, -> user_id, namespace {
          where('user_id = ?', user_id).
          where('name = ?', namespace.downcase) if namespace.present?
        }

  ## -------------------- Instance method ----------------------- ##

  ##
  # edit a space, only can edit the description for now
  #
  def edit_space(description)
    update!(description: description)
  end

  ##
  # edit a space, only can edit the namespace for now
  #
  def change_space(namespace)
    update!(name: namespace)
  end

  ##
  # delete a space
  #
  def delete_space(namespace)
    if namespace.nil? || namespace.downcase != name
      raise StandardError, 'The namespace is not valid'

    if Project.exists?(space_id: id)
      raise StandardError, 'This space can not be delete because it has'\
                           ' one or more projects associate'

    destroy!
  end

  ##
  # Transfer space and projects to a member team
  #
  def transfer(user, user_member_id)
    if user.nil? || user_member_id.nil? || !Team.find_member(user.id, user_member_id).exists?
      raise StandardError, 'The member is not valid'

    user = User.find(user_member_id)
    raise StandardError, 'The team member can not add more spaces,'\
              ' please contact with us!' unless Space.can_create_space?(user)

    transfer_projects user_member_id

    member_email = Email.find_primary_by_user(user_member_id).take
    Notifier.send_transfer_space_email(member_email, user, self)
        .deliver_later unless member_email.nil?
  end

  ## ------------------------ Class method ------------------------ ##

  ##
  # add a new space
  #
  def self.create_new_space(space_params, user, user_owner)
    raise StandardError, 'You can not add more spaces,'\
              ' please contact with us!' unless can_create_space?(user)

    Space.create!(
        name: space_params[:name],
        description: space_params[:description],
        user_id: user.id,
        user_owner_id: user_owner.id)
  end

  private

  ## ------------------ Private Instance method -------------------- ##

  ##
  # Transfer all the projects belong space
  #
  def transfer_projects(user_member_id)
    self.update!(user_id: user_member_id)
    Project.where('space_id = ?', self.id).find_each do |p|
      p.update!(user_id: user_member_id)
    end
  end

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters, - and _
  #
  def name_format
    self.name.gsub!(/[^0-9a-z\-_ ]/i, '_') unless self.name.nil?
    self.name.gsub!(/\s+/, '-') unless self.name.nil?
    self.name = self.name.downcase unless self.name.nil?
  end

  ## -------------------- Private Class method ----------------------- ##

  ##
  # If i can added more space, free account such has 3 spaces permitted
  #
  def self.can_create_space?(user)
    return false if user.nil?
    spaces_count = Space.count_by_user user.id
    value = user.plan.find_plan_value('Amount of spaces')
    spaces_count < value.to_i
  end
end
