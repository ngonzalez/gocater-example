module ExampleHelpers
  def check_array array, item
    array.map { |name| name[:first_name] }.include?(item[:first_name]) &&
    array.map { |name| name[:last_name] }.include?(item[:last_name])
  end

  def item_hash item
    last_name, first_name = item.split(',').map &:strip
    { last_name: last_name, first_name: first_name }
  end
end
