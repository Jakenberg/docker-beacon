class User < ActiveRecord::Base
  include IdentitiesHelper

  has_many :identities, class_name: 'Identity', dependent: :destroy
  has_many :zones, dependent: :destroy

  def self.find_or_create_from_omniauth(auth)
    params = {uid: auth[:uid], provider: auth[:provider]}
    identity = Identity.find_by(params)
    unless identity.present?
      params['user_id'] = create.id
      identity = Identity.new(params)
      identity.url = identity_url(auth)
      identity.save
    end
    identity.user
  end

end