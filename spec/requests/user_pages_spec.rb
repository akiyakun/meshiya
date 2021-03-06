require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "profile page" do
		let( :user ) { FactoryGirl.create( :user ) }
		let!( :m1 ) { FactoryGirl.create( :micropost, user: user, content: "Foo" ) }
		let!( :m2 ) { FactoryGirl.create( :micropost, user: user, content: "Bar" ) }

		before { visit user_path( user ) }

		it { should have_content( user.name ) }
		it { should have_title( user.name ) }

		describe "micropostes" do
			it { should have_content( m1.content ) }
			it { should have_content( m2.content ) }
			it { should have_content( user.microposts.count ) }
		end
	end

	describe "signup page" do
		before { visit signup_path }

		it { should have_content( _t('w.signup') ) }

	end

	describe "signup" do
		before { visit signup_path }

		let( :submit ) { _t('users.new.submit') }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change( User, :count )
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_title( _t('w.signup') ) }
				it { should have_content( _t('w.error') ) }
			end
		end

		describe "with valid information" do
			before do
				fill_in "user_name",					with: "Example User"
				fill_in "user_email",					with: "user@example.com"
				fill_in "user_password",				with: "foobar"
				fill_in "user_password_confirmation",	with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change( User, :count ).by( 1 )
			end

			# create アクションで保存が行われた後の動作のテスト
			describe "after saving the user" do
				before { click_button submit }
				let( :user ) { User.find_by( email: 'user@example.com' ) }

				it { should have_link( _t('w.signout') ) }
				it { should have_title( user.name ) }
				it { should have_welcome_message( 'Welcome' ) }
			end
		end
	end

	describe "edit page" do
		let( :user ) { FactoryGirl.create( :user ) }

		before do
			t_push 'users.edit'
			sign_in user
			visit edit_user_path( user )
		end

		after do
			t_pop
		end

		describe "page" do
			it { should have_content( t('.header') ) }
			it { should have_title( t('.title') ) }
			it { should have_link( t('.change'), href: 'http://gravatar.com/emails' ) }
		end

		describe "with invalid information" do
			let( :new_name )  { "New Name" }
			let( :new_email ) { "new@example.com" }

			before do
				fill_in "user_name",					with: new_name
				fill_in "user_email",					with: new_email
				fill_in "user_password",				with: user.password
				fill_in "user_password_confirmation",	with: user.password
				click_button t('.submit')
			end

			it { should have_title( new_name ) }
			it { should have_selector( 'div.alert.alert-success' ) }
			it { should have_link( _t('w.signout'), href: signout_path ) }
			specify { expect( user.reload.name ).to  eq new_name }
			specify { expect( user.reload.email ).to eq new_email }
		end
	end

	describe "index" do
		let( :user ) { FactoryGirl.create( :user ) }

		before( :each ) do
			sign_in user
			visit users_path
		end

		it { should have_title( _t('users.index.title') ) }
		it { should have_content( _t('users.index.title') ) }

		describe "pagination" do
			before( :all )	{ 30.times { FactoryGirl.create( :user ) } }
			after( :all )	{ User.delete_all }

			it { should have_selector( 'div.pagination' ) }

			it "should list each user" do
				User.paginate( page: 1, per_page: 10 ).each do |user|
					expect( page ).to have_selector( 'li', text: user.name )
				end
			end
		end

		describe "as an admin user" do
			let( :admin ) { FactoryGirl.create( :admin ) }
			let( :delete ) { _t('users.user.delete') }

			before do
				sign_in admin
				visit users_path
			end

			it { should have_link( delete, href: user_path( User.first ) ) }

			it "should be able to delete another user" do
				expect do
					click_link( delete, match: :first )
				end.to change( User, :count ).by( -1 )
			end

			it { should_not have_link( delete, href: user_path( admin ) ) }
		end
	end
end
