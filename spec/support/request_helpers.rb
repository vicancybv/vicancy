def post_json(path, params)
  post path, params.to_json, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
end
