require 'yard'
YARD::Registry.load!.all.each do |os|
  if os.has_tag?(:todo)
    puts "- #{os.file}"
    os.tags(:todo).each do |o|
      puts "@todo #{o.text}"
    end
  end
end
