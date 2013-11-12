ActiveAdmin.register User do

  form do |f|
    f.inputs 'User' do
      f.input :name, label: "Reseller name"
      f.input :slug, label: "Address", hint: "e.g. aw6g39vk. Created automatically if left blank."
    end
    f.inputs 'Videos' do
      f.has_many :videos, :heading => 'Videos' do |video|
        
      end
    end
    f.actions
  end
  
end
