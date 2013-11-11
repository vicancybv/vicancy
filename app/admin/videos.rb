ActiveAdmin.register Video do

  form do |f|
    f.inputs 'Video' do
      f.input :youtube_id, label: "YouTube ID", hint: "e.g. xxx"
      f.input :vimeo_id, label: "Vimeo ID", hint: "e.g. xxx"
    end
    f.inputs 'Caption' do
      f.input :language,  
              as: :select,      
              collection: { 
                "English" => "en", 
                "Dutch" => "nl"
              }
      f.input :title
      f.input :summary
    end
    f.inputs 'Job' do
      f.input :job_title
      f.input :company
      f.input :job_ad_url
    end
    f.actions
  end
  
end
