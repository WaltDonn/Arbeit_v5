class HomeController < ApplicationController
  def home
    if logged_in?
      flash_codes
      # get my projects
      @projects = current_user.projects.alphabetical.to_a
      project_ids = @projects.map(&:id)

      # get my incomplete tasks
      incomplete_tasks = Task.incomplete.map{|task| task if project_ids.include?(task.project_id)}.compact
      @incomplete_tasks = Task.where(id: incomplete_tasks.map(&:id)).paginate(page: params[:page], per_page: 3).by_priority

      # get my completed tasks
      @completed_tasks = Task.by_name.completed.map {|task| task if project_ids.include?(task.project_id) }
    end
  end

  def about
  end

  def privacy
  end

  def contact
  end

end
