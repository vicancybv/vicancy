ActiveAdmin.register Client do

  action_item only: :show do |client|
    link_to('New Video for this Client', new_admin_video_url('video[client_id]' => params[:id]))
  end

  index do
    selectable_column
    column :id
    column :name
    column :language
    column 'Address' do |client|
      link_to client.slug, client_url(client.slug)
    end
    column :email
    column :external_id
    column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs 'Reseller' do
      f.input :reseller
    end
    f.inputs 'Client' do
      f.input :name, label: "Client name"
      f.input :email
      f.input :external_id, label: "External Client ID", hint: "Created automatically if left blank."
      f.input :slug, hint: "e.g. aw6g39vk. Created automatically if left blank."
      f.input :token, hint: "Created automatically if left blank."
      f.input :language,
              as: :select,
              collection: {
                  "English" => "en",
                  "Dutch" => "nl"
              }
    end
    f.actions
  end

  show do |reseller|
    attributes_table do
      row 'Reseller' do |client|
        link_to(client.reseller_name, admin_reseller_url(client.reseller)) if client.reseller.present?
      end
      row :id
      row :name
      row :email
      row :external_id
      row :token
      row :language
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :url do |user|
        link_to client_url(client.slug), client_url(client.slug)
      end
    end

    panel "Videos" do
      table_for client.videos do
        column "ID" do |video|
          link_to video.id, edit_admin_video_url(video)
        end
        column '' do |video|
          img src: video.thumbnail_url({size: '50x50', crop: :fit})
        end
        column :company
        column :job_title
        column :created_at
        column do |video|
          links = ''.html_safe
          links << link_to(I18n.t('active_admin.view'), admin_video_path(video), :class => "member_link view_link")
          links << link_to(I18n.t('active_admin.edit'), edit_admin_video_path(video), :class => "member_link edit_link")
          links << link_to(I18n.t('active_admin.delete'), admin_video_path(video), :method => :delete, :data => { :confirm => I18n.t('active_admin.delete_confirmation') }, :class => "member_link delete_link")
          links
        end
      end
    end

    panel "Video requests" do
      table_for client.video_requests do
        column "ID" do |video_request|
          link_to video_request.id, admin_video_request_url(video_request)
        end
        column :link
        column :comment
        column :files do |video_request|
          video_request.attachments.count
        end
      end
    end

  end

end