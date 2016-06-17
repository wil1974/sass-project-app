class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validate :email_is_unique, on: :create
  after_create :create_account

  #set to true if you want email confirmation
  def confirmation_required?
    false
  end

  private
  #Email should be unique in Account model
  def email_is_unique
    #don't validate email if errors already present
    return false unless self.errors[:email].empty?

    unless Account.find_by_email(email).nil?
      errors.add(:email, " is already taken by another account")
    end
  end

  #create account to link to user email
  # everytime a new user is registered thru devise
  def create_account
    account = Account.new(:email => email)
    account.save!
  end
end
