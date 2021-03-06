require 'spec_helper'

describe "Authentication" do
	subject { page }

	before do
		t_push( 'layouts.header_signed_in' )
	end

	after do
		t_pop
	end

	describe "signin page" do
		before { visit signin_path }

		it { should have_content( _t('w.signin') ) }
		it { should have_title( _t('w.signin') ) }
		it { should_not have_link( t('.profile') ) }
		it { should_not have_link( t('.settings') ) }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button _t('w.signin') }

			it { should have_title( _t('w.signin') ) }
			it { should have_selector( 'div.alert.alert-error', text: 'Invalid' ) }
			it { should_not have_link( t('.profile') ) }
			it { should_not have_link( t('.settings') ) }

			describe "after visiting another page" do
				before { click_link _t('static_pages.home.title') }
				it { should_not have_selector( 'div.alert.alert-error' ) }
			end
		end


		describe "with valid information" do
			let(:user) { FactoryGirl.create( :user ) }

			before { sign_in user }

			it { should have_title( user.name ) }
			it { should have_link( t('.users'),			href: users_path ) }
			it { should have_link( t('.profile'),		href: user_path( user ) ) }
			it { should have_link( t('.settings'),		href: edit_user_path( user ) ) }
			it { should have_link( _t('w.signout'),		href: signout_path ) }
			it { should_not have_link( _t('w.signin'),	href: signin_path ) }

			describe "followed by signout" do
				before { click_link _t('w.signout') }
				it { should have_link( _t('w.signin') ) }
			end
		end
	end

	describe "authorization" do
		before { t_push 'users.fields' }
		after { t_pop }

		describe "for non-signed-in users" do
			let( :user ) { FactoryGirl.create( :user ) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path( user )
					fill_in 'session_email',		with: user.email
					fill_in 'session_password',		with: user.password
					sign_in user
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						expect( page ).to have_title( _t('users.edit.title') )
					end
				end

				describe "when signing in again" do
					before do
						delete signout_path
						visit signin_path
						fill_in 'session_email',		with: user.email
						fill_in 'session_password',		with: user.password
						sign_in user
					end

					it "should render the default ( profile ) page" do
						expect( page ).to have_title( user.name )
					end
				end
			end

			describe "in the Users controller" do
				describe "visiting the edit page" do
					before { visit edit_user_path( user ) }
					it { should have_title( _t('w.signin') ) }
				end

				describe "submitting to the update action" do
					before { patch user_path( user ) }
					specify { expect( response ).to redirect_to( signin_path ) }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title( _t('w.signin') ) }
				end
			end

			describe "in the Microposts controller" do
				describe "submitting to the create action" do
					before { post microposts_path }
					specify { expect( response ).to redirect_to( signin_path ) }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path( FactoryGirl.create( :micropost ) ) }
					specify { expect( response ).to redirect_to( signin_path ) }
				end
			end
		end

		describe "as wrong user" do
			let( :user ) { FactoryGirl.create( :user ) }
			let( :wrong_user ) { FactoryGirl.create( :user, email: "wrong@example.com" ) }

			before { sign_in user, no_capybara: true }

			describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path( wrong_user ) }
				specify { expect( response.body ).not_to match( full_title( _t('users.edit.title') ) ) }
				specify { expect( response ).to redirect_to( signin_path ) }
			end

			describe "submitting a PATCH request to the Users#update action" do
				before { patch user_path( wrong_user ) }
				specify { expect( response ).to redirect_to( signin_path ) }
			end
		end

		describe "as non-admin user" do
			let( :user ) { FactoryGirl.create( :user ) }
			let( :non_admin ) { FactoryGirl.create( :user ) }

			before { sign_in non_admin, no_capybara: true }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path( user ) }
				specify { expect( response ).to redirect_to( signin_path ) }
			end
		end

		describe "as an admin user" do
			let( :admin ) { FactoryGirl.create( :admin ) }

			before do
				sign_in admin, no_capybara: true
			end

			describe "submitting a DELETE request to the User#destroy action" do
				before { delete user_path( admin ) }
				specify { expect( response ).to redirect_to( signin_path ) }
			end
		end
	end

end
