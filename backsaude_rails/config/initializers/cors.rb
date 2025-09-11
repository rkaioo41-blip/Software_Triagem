Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:8081" # ou '*' para testes

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: false
  end
end
