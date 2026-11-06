module RequestHelpers
  def expect_not_found_page
    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("Страница не найдена")
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
