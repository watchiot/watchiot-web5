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

  scope :count_spaces, -> user { where('user_id = ?', user.id)
          .count unless user.nil?
        }

  scope :find_spaces, -> user { where('user_id = ?', user.id)
          .order(created_at: :desc).all unless user.nil?
        }

  scope :find_space, -> user, namespace { where('user_id = ?', user.id)
          .where('name = ?', namespace.downcase) if namespace.present? && !user.nil?
        }

  ##
  # edit a space, only can edit the description for now
  #
  def update_description(description)
    update!(description: description)
  end

  ##
  # edit a space, only can edit the namespace for now
  #
  def update_namespace(namespace)
    update!(name: namespace)
  end

  ##
  # delete a space
  #
  def delete_space(namespace)
    if namespace.nil? || namespace.downcase != self.name
      raise StandardError, 'The namespace is not valid'
    end

    if Project.exists?(space_id: self.id)
      raise StandardError, 'This space can not be delete because it has'\
                         ' one or more projects associate'
    end

    destroy!
  end

  ##
  # Transfer space and projects to a member team
  #
  def transfer(user, user_member, email_member)
    if user.nil? || user_member.nil? || !Team.find_member(user, user_member).exists?
      raise StandardError, 'The member is not valid'
    end

    raise StandardError, 'The team member can not add more spaces,'\
              ' please contact with us!' unless Space.can_create_space?(user_member)

    transfer_projects user_member

    Notifier.send_transfer_space_email(email_member.email, user, self)
        .deliver_later unless email_member.nil?
  end

  ##
  # add a new space
  #
  def self.create_new_space(space_params, user, user_owner)
    raise StandardError, 'You can not add more spaces,'\
              ' please contact with us!' unless can_create_space?(user)

    Space.create!(
        name: space_params[:name],
        description: space_params[:description],
        user: user,
        user_owner_id: user_owner.id)
  end

  private

  ##
  # Transfer all the projects belong space
  #
  def transfer_projects(user_member)
    self.update!(user: user_member)
    Project.where('space_id = ?', self.id).find_each do |p|
      p.update!(user: user_member)
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

  ##
  # If i can added more space, free account such has 3 spaces permitted
  #
  def self.can_create_space?(user)
    return false if user.nil?

    spaces_count = Space.count_spaces user
    value = user.plan.find_plan_value('Amount of spaces')
    spaces_count < value.to_i
  end
end
