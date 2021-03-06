class Topic < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :delete_all
  has_many :videos, dependent: :delete_all
  has_many :notes, dependent: :delete_all

  def parent
    if self.parent_id != nil && self.parent_id != 0
      Topic.find(self.parent_id)
    end
  end

  def children
    Topic.where(parent_id: self.id)
  end

  def ancestors
    ancestors = []
    ancestors << self
    until ancestors.last.parent_id == 0 || ancestors.last.parent == nil
      ancestors << recursion(ancestors.last)
    end
    ancestors.shift
    ancestors
  end

  private

  def recursion(topic)
    topic.parent
  end

end
