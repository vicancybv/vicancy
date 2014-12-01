ActiveAdmin.register Reseller do

  action_item only: :show do |reseller|
    link_to('New Client for this Reseller', new_admin_client_url('client[reseller_id]' => params[:id]))
  end

  form do |f|
    f.inputs 'Reseller' do
      f.input :name, label: "Reseller name"
      f.input :slug, hint: "e.g. aw6g39vk. Created automatically if left blank."
      f.input :token, hint: "Created automatically if left blank."
      f.input :secret, hint: "Created automatically if left blank."
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
      row :id
      row :name
      row :token
      row :secret
      row :language
      row :url do |user|
        link_to reseller_url(reseller.slug), reseller_url(reseller.slug)
      end
    end

    panel "Clients" do
      table_for reseller.clients.order(:name) do
        column "ID" do |client|
          link_to client.id, edit_admin_client_url(client)
        end
        column :name
        column :url do |client|
          link_to 'view', client_url(client.slug)
        end
        column :language
        column :created_at
        column do |client|
          links = ''.html_safe
          links << link_to(I18n.t('active_admin.view'), admin_client_path(client), :class => "member_link view_link")
          links << link_to(I18n.t('active_admin.edit'), edit_admin_client_path(client), :class => "member_link edit_link")
          links << link_to(I18n.t('active_admin.delete'), admin_client_path(client), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link")
          links
        end
      end
    end
  end
  
end
