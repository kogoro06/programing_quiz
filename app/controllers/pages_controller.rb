class PagesController < ApplicationController
  def contact
    render "contacts/new"
  end

  def terms
    render "terms_of_services/index"
  end

  def privacy
    render "privacy_policies/index"
  end
end
