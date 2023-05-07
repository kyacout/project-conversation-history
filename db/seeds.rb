# frozen_string_literal: true

require 'factory_bot_rails' # Add this line to require FactoryBot
include FactoryBot::Syntax::Methods # Include FactoryBot methods

# Create 10 users using the :user factory
10.times do
  create(:user)
end

# Create 10 projects using the :project factory
20.times do
  create(:project)
end

# Create 100 comments using the :comment factory
100.times do
  project = Project.all.sample
  user = User.all.sample
  create(:comment, project:, author: user)
  create(:project_history, :comment, project:, user:)
end

# Create 100 status_update in the past using the :status_update trait in the :project_history factory
100.times do
  create(:project_history, :status_update, project: Project.all.sample, user: User.all.sample)
end
