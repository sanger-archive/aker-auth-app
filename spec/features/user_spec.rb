require 'rails_helper'

RSpec.describe User, type: :feature do
  before do
    @user = User.create!(email: "user@sanger.ac.uk")
  end

  def submit_form(email='user')
    fill_in "user_email", with: email
    fill_in "user_password", with: "password"
    click_button "Log in"
  end

  describe "signing in" do
    context "with a redirect URL present" do
      it "redirects to the given URL" do
        visit "/login?redirect_url=https://www.google.de"
        submit_form
        expect(current_url).to eq("https://www.google.de/")
      end
    end

    context "without a redirect URL present" do
      it "redirects to the default URL" do
        visit "/login"
        submit_form('user@sanger.ac.uk')
        expect(current_path).to eq("/dashboard")
      end
    end
  end

  describe "accessing the sign in form while logged in" do
    context "without a redirect URL present" do
      it "redirects to the default URL" do
        visit "/login"
        submit_form
        visit "/login"
        expect(current_path).to eq("/dashboard")
      end
    end

    context "with a redirect URL present" do
      it "redirects to the given URL" do
        visit "/login"
        submit_form
        visit "/login?redirect_url=https://www.google.fr"
        expect(current_url).to eq("https://www.google.fr/")
      end
    end

  end

  describe "signing out" do
    context "while logged in" do
      before :each do
        sign_in @user
        page.driver.submit :delete, logout_path, {}
      end

      it "redirects to the login page" do
        expect(current_path).to eq("/")
      end

      it "shows a flash saying the sign out was successful" do
        expect(page).to have_content("Signed out successfully.")
      end
    end
  end

end
