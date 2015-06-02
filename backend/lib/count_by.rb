# count_by.rb
# License: MIT
#
# Authors: Benjamin Oakes, Dan Bernier

module Enumerable
  def count_by(&block)
    group_by(&block).map { |criteria, group| [criteria, group.count] }
  end
end
