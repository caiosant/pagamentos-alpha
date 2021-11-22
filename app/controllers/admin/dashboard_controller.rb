class Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin!, only: %i[index]
    def index; end
  end
end
