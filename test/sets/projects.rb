module Contexts
  module Projects
    # Context for projects (assumes contexts for domains, users)
    def create_projects
      @arbeit       = FactoryBot.create(:project, domain: @software, manager: @ted, start_date: 1.week.ago.to_date, end_date: nil)
      @proverbs     = FactoryBot.create(:project, name: 'Proverbs', domain: @software, manager: @ed, start_date: 9.weeks.ago.to_date, end_date: nil)
      @bookmanager  = FactoryBot.create(:project, name: 'BookManager', domain: @software, manager: @fred, start_date: 8.weeks.ago.to_date, end_date: nil)
      @choretracker = FactoryBot.create(:project, name: 'ChoreTracker', domain: @software, manager: @fred, start_date: 7.weeks.ago.to_date)
    end
    
    def destroy_projects
      @arbeit.destroy
      @proverbs.destroy
      @bookmanager.destroy
      @choretracker.destroy

    end
  end
end