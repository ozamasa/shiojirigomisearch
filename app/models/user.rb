class User < ActiveRecord::Base
  require 'digest/sha1'

#  belongs_to : 
#  has_many   : 
#  validates_presence_of     : 
#  validates_uniqueness_of   : , :on => :create
#  validates_length_of       : , :maximum => 255
#  validates_numericality_of : , :greater_than => 0, :less_than => 10000000, :if => : ?
#  validates_format_of       :zenkaku,  :with => REGEXP_ZENKAKU,  :message => :not_a_zenkaku
#  validates_format_of       :hankaku,  :with => REGEXP_HANKAKU,  :message => :not_a_hankaku
#  validates_format_of       :password, :with => REGEXP_PASSWORD, :message => :not_a_password, :allow_blank => true
#  validates_format_of       :email,    :with => REGEXP_EMAIL,    :message => :not_a_email,    :if => :email?
#  validates_format_of       :zip,      :with => REGEXP_ZIP,      :message => :not_a_zip,      :if => :zip?
#  validates_format_of       :tel,      :with => REGEXP_TEL,      :message => :not_a_tel,      :if => :tel?
#  named_scope :, :conditions => ""

  validates_presence_of     :name
  validates_length_of       :name,     :maximum => 50
#  validates_format_of       :name,     :with => REGEXP_ZENKAKU, :message => :not_a_zenkaku
  validates_presence_of     :account
  validates_length_of       :account,  :maximum => 50
  validates_uniqueness_of   :account
#  validates_format_of       :account,  :with => REGEXP_HANKAKU, :message => :not_a_hankaku
  validates_presence_of     :password
  validates_length_of       :password, :maximum => 50
#  validates_format_of       :password, :with => REGEXP_PASSWORD, :message => :not_a_password, :allow_blank => true
  validates_confirmation_of :password

  attr_accessor :password_confirmation
  attr_accessor :password_required

  #attr_accessor :password
  def password
    @password
  end
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password  = User.encrypted_password(self.password, self.salt)
#    self.password_updated = Time.now
  end

  def self.authenticate(id, password)
    user = self.find_by_account(id)
    if user
      if (user.hashed_password.blank? || user.salt.blank?) && (password.blank? || id == password)
        user.password = id
        user.update_attribute(:hashed_password, user.hashed_password)
        user.update_attribute(:salt, user.salt)
      else
        expected_password = encrypted_password(password, user.salt)
        if user.hashed_password != expected_password
          user = nil
        end
      end
    end
    user
  end

private
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "1qazxsw2" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
end
