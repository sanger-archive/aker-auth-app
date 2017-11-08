class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable

  attr_accessor :groups

  validates :email, presence: true, uniqueness: true

  before_validation :sanitise_email
  before_save :sanitise_email

  def groups
    @groups ||= fetch_groups
  end

private

  def fetch_groups
    return ['pirates', 'world'] if Rails.configuration.fake_ldap
    # Cache groups to prevent unecessary LDAP requests
    Rails.cache.fetch("#{cache_key}/groups", expires_in: 12.hours) do
      name = self.email
      DeviseLdapAuthenticatable::Logger.send("Getting groups for #{name}")
      connection = Devise::LDAP::Adapter.ldap_connect(name)
      filter = Net::LDAP::Filter.eq("member", connection.dn)
      connection.ldap.search(filter: filter, base: Rails.application.config.ldap["group_base"]).collect(&:cn).flatten.push('world')
    end
  end

  def sanitise_email
    if email
      sanitised = email.strip.downcase
      if sanitised != email
        self.email = sanitised
      end
    end
  end
end
