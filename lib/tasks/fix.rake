
namespace :fix do
  desc 'Fix html issues with names for clients like &amp;amp;amp; in names'
  task names: :environment do
    Client.all.each do |client|
      md = /&(amp;)+/.match(client.name)
      if md
        puts "Found problem: #{client.name}"
        new_name = client.name.gsub(/&(amp;)+/, '&')
        client.update_attribute(:name, new_name)
        puts "  -> #{new_name}"
      end
    end
  end

end
