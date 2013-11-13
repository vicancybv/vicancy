ActiveAdmin.register Video do

  form do |f|
    f.inputs I18n.t('admin.User') do
      f.input :user
    end
    f.inputs I18n.t('admin.Video') do
      f.input :youtube_id, label: "YouTube ID", hint: "#{I18n.t('admin.eg')} n3UkHTcbwb4"
      f.input :vimeo_id, label: "Vimeo ID", hint: "#{I18n.t('admin.eg')} 77573345"
    end
    f.inputs I18n.t('admin.Caption') do
      f.input :language,  
              as: :select,      
              collection: { 
                "English" => "en", 
                "Dutch" => "nl"
              }
      f.input :title, hint: I18n.t(:'admin.optional')
      f.input :summary, hint: I18n.t(:'admin.optional')
    end
    f.inputs I18n.t(:'admin.Job') do
      f.input :job_title
      f.input :company
      f.input :job_ad_url
    end
    f.actions
  end
  
end
