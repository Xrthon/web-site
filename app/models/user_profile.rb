class UserProfile < ApplicationRecord
  belongs_to :user
  before_validation :set_default_theme_color

  HEADER_COLORS = {
    "gray" => "from-gray-900 to-gray-700",
    "blue" => "from-blue-900 to-blue-700",
    "red" => "from-red-900 to-red-700",
    "green" => "from-green-900 to-green-700",
    "purple" => "from-purple-900 to-purple-700",
    "pink" => "from-pink-900 to-pink-700"
  }.freeze

  def header_gradient
    HEADER_COLORS[theme_color] || HEADER_COLORS["gray"]
  end
  
  private

  def set_default_theme_color
    self.theme_color ||= "gray"
  end

end
