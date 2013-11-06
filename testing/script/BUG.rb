require 'yard'
YARD::Registry.load!.all.each do |os|
  if os.has_tag?(:bug)
    puts "- #{os.file}"
    os.tags(:bug).each do |o|
      puts "@bug #{o.type} #{o.name} #{o.text}"
    end
  end
end
