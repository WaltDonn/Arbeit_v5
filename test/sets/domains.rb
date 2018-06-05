module Contexts
  module Domains
    # Context for domains
    def create_domains
      @software = FactoryBot.create(:domain)
      @academic = FactoryBot.create(:domain, name: 'Academic')
      @personal = FactoryBot.create(:domain, name: 'Personal')
      @poetry   = FactoryBot.create(:domain, name: 'Poetry', active: false)
    end
    
    def destroy_domains
      @software.destroy
      @academic.destroy
      @personal.destroy
      @poetry.destroy
    end
  end
end