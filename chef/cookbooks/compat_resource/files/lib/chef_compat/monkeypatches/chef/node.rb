class Chef
  class Node
    unless method_defined?(:set_cookbook_attribute)
      def set_cookbook_attribute
        # this implementation deliberately left blank - we don't need to do anything we just need to not fail
      end
    end
  end
end
