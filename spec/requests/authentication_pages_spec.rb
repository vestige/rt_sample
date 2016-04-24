require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
      before { visit signin_path }

      it {should have_content('Sign in')}
      it {should have_title('Sign in')}
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid infomation" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
      describe "after visitting another page" do
        before { click_link "Home" }
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    describe "with valid infomation" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out"}
        it { should have_link('Sign in') }
      end
    end    
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the User controller" do
        describe "visitting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
  end
end
