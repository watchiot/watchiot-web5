# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  configuration :text
#  ready         :boolean          default(FALSE)
#  status        :boolean          default(TRUE)
#  user_id       :integer
#  space_id      :integer
#  user_owner_id :integer
#  repo_name     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Project < ApplicationRecord
  belongs_to :user
  belongs_to :space

  validates_presence_of :name, on: :create
  validates_uniqueness_of :name, scope: [:space_id, :user_id],
                          message: 'You have a project with this name'

  validates :name, presence: true, length: { maximum: 25 }
  validates :name, exclusion: { in: %w(create setting projects),
                                message: '%{value} is reserved.' }

  before_validation :name_format

  scope :count_projects, -> user_id, space_id {
          where('user_id = ?', user_id).
          where('space_id = ?', space_id).count
        }

  scope :find_project, -> user_id, space_id, project {
          where('user_id = ?', user_id).
          where('space_id = ?', space_id).
          where('name = ?', project.downcase) if project.present?
        }

  ## -------------------- Instance method ----------------------- ##

  ##
  # edit a project, only can edit the description for now
  #
  def edit_project(description, status)
    update!(description: description, status: status)
  end

  ##
  # edit a project, only can edit the name for now
  #
  def change_project(name)
    update!(name: name)
  end

  ##
  # delete a project
  #
  def delete_project(name)
    raise StandardError, 'The project name is not valid' if name.nil? || name.downcase != self.name

    destroy!
  end

  ##
  # save the configuration and if it has errors
  #
  def save_project_config(yaml, repo_name, ready)
    update!(configuration: yaml, ready: ready)
    update!(repo_name: repo_name) unless repo_name.blank?
  end

  ## ------------------------ Class method ------------------------ ##

  ##
  # add a new space
  #
  def self.create_new_project(project_params, user, space, user_owner)
    raise StandardError, 'You can not add more projects,'\
              ' please contact with us!' unless can_create_project?(user, space)

    Project.create!(
        name: project_params[:name],
        description: project_params[:description],
        user_id: user.id,
        space_id: space.id,
        user_owner_id: user_owner.id)
  end

  ##
  # this method evaluate yaml configuration code syntactic
  # and return an array of errors if there are
  #
  def self.evaluate(config)
    errors = WiotParser.parse(config, nil)
    fix_error_line(errors)
  end

  ##
  # this method return all the token defined
  #
  def self.token
    WiotParser.token
  end

  ##
  # The ace editor count the line begin in zero, then
  # we have to fix it
  #
  def self.fix_error_line(errors)
    return if errors.nil? || errors.empty?

    errors.each do |key, value|
      row = value.row
      row_i = row.to_i - 1
      value.row = row_i.to_s
    end
  end

  ##
  # Get the repos configurations predefine info
  #
  def self.repos_config(repo_url)
    uri = URI(repo_url +'repos')
    req = Net::HTTP.get(uri)
    JSON.parse req
  end

  ##
  # Get the yaml config
  #
  def self.config_yaml(repo_url, config_name)
    uri = URI(repo_url + 'repos/' + config_name + '/config.yml')
    req = Net::HTTP.get(uri)
    JSON.parse req
  end

  ##
  # Get the readme.md config
  #
  def self.config_readme(repo_url, config_name)
    uri = URI(repo_url + 'repos/' + config_name + '/readme.md')
    req = Net::HTTP.get(uri)
    json_readme = JSON.parse req
    # convert markdown to html
    readme = Markdown.new(json_readme['readme']).to_html
    # replace all the \n for <br />
    readme.gsub("\n", "<br />")
  end

  private

  ## -------------------- Private Instance method ----------------------- ##

  ##
  # Format name field, lowercase and '_' by space
  # Admitted only alphanumeric characters
  #
  def name_format
    self.name.gsub!(/[^0-9a-z\-_ ]/i, '_') unless self.name.nil?
    self.name.gsub!(/\s+/, '-') unless self.name.nil?
    self.name = self.name.downcase unless self.name.nil?
  end

  ## -------------------- Private Class method ----------------------- ##

  ##
  # If i can added more projects, free account such has 5 projects per space permitted
  #
  def self.can_create_project?(user, space)
    return false if user.nil? || space.nil?
    projects_count = Project.count_projects user.id, space.id
    value = user.plan.find_plan_value('Amount of projects by space')
    projects_count < value.to_i
  end
end
