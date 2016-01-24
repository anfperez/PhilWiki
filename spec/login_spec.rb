require "capybara/rspec"
require "selenium-webdriver"
require "pry"
require_relative "../login_server"

Selenium::WebDriver::Firefox::Binary.path="/opt/homebrew-cask/Caskroom/firefox/38.0.5/Firefox.app/Contents/MacOS/firefox-bin"
Capybara.app = LoginServer

RSpec.describe LoginServer, type: :feature, js: true do

  it "lets me sign up" do
    visit "/signup"
    fill_in :login_name, with: "jaden"
    fill_in :login_password, with: "testpassword"
    click_button "Sign up"
    expect(page.body).to include("Thank you!")
    binding.pry
  end

end