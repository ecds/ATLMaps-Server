class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :institution

  has_many :collaboration
  has_many :projects, through: :collaboration, dependent: :destroy
  has_many :user_tagged, dependent: :destroy

  def number_tagged
    return self.user_tagged.count
  end

end
