ActiveAdmin.register UploadedVideo do

  # show do |uploaded_video|
  #
  #   attributes_table do
  #     # row 'Client' do |video|
  #     #   video.client.present? ? link_to(video.client_name, admin_client_url(video.client)) : nil
  #     # end
  #     # row '(User)' do |video|
  #     #   video.user.present? ? link_to("(#{video.user_name})", admin_user_url(video.user)) : nil
  #     # end
  #     row :provider
  #     row :video
  #     row :external_job_id
  #     row :job_title
  #     row :job_ad_url
  #     row :job_url
  #     row :short_job_url
  #     row :company
  #     row :aasm_state
  #   end
  #
  # end

  action_item only: [:show, :edit] do |video|
    link_to('Rebuild Thumbnail', rebuild_thumbnail_admin_uploaded_video_url)
  end

  sidebar "Thumbnail", only: :show do
    if uploaded_video.thumbnail.blank?
      span 'No thumbnail. Rebuild it by clicking on button above.'
    else
      span do
        img src: uploaded_video.thumbnail_url({ size: '200x200', crop: :fit })
      end
      br
      span "Size: #{uploaded_video.thumbnail.width}x#{uploaded_video.thumbnail.height}"
      br
      span "Format: #{uploaded_video.thumbnail.format}"
      br
      link_to 'Thumbnail url', uploaded_video.thumbnail_url
    end
  end

  index do
    selectable_column
    column '' do |uploaded_video|
      img src: uploaded_video.thumbnail_url({size: '50x50', crop: :fit})
    end
    column :provider
    column 'Provider ID', :provider_id
    column :aasm_state
    column :thumbnail_source
    column :updated_at
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Uploaded Video' do
      f.input :video
      f.input :provider_id, label: "Provider ID"
      f.input :aasm_state, label: "State",
              collection: ["processing", "uploaded", "error"]
      f.input :provider,
              as: :select,
              collection: {
                  "YouTube" => "youtube",
                  "Vimeo" => "vimeo",
                  "Wistia" => "wistia"
              }
    end
    f.actions
  end

  member_action :rebuild_thumbnail, method: :get do
    resource.build_thumbnail
    redirect_to resource_path, notice: "Thumbnail rebuilt!"
  end
end                                   
