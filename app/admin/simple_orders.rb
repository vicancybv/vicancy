ActiveAdmin.register SimpleOrder do
  index do
    selectable_column
    column :id
    column :product
    column :name
    column :email
    column :url
    column :referer
    column :created_at
    column :updated_at
    actions
  end
end
