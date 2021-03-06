require 'spec_helper'

describe "Static pages" do
	subject { page }

	shared_examples_for "all static pages" do
		it { should have_content( heading ) }
		it { should have_title( full_title( page_title ) ) }
	end

	describe "Home page" do
		before { visit root_path }
		let( :heading )		{ _t('shared.home_no_signed_in.welcome_msg') }
		let( :page_title )	{ '' }

		it_should_behave_like "all static pages"
		it { should_not have_title( '| ' + _t('static_pages.home.title') ) }

		describe "for signed-in users" do
			let( :user ) { FactoryGirl.create( :user ) }

			before do
				FactoryGirl.create( :micropost, user: user, content: "Lorem ipsum" )
				FactoryGirl.create( :micropost, user: user, content: "Dolor sit amet" )
				sign_in user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					expect( page ).to have_selector( "li##{item.id}", text: item.content )
				end
			end
		end
	end

	describe "Help page" do
		before { visit help_path }
		let( :heading )		{ 'Help' }
		let( :page_title )	{ '' }

		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }
		let( :heading )		{ 'About' }
		let( :page_title )	{ '' }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }
		let( :heading )		{ 'Contact' }
		let( :page_title )	{ '' }

		it_should_behave_like "all static pages"
	end

	it "should have the right links on the layot" do
		visit root_path

		# click_link t('w.about')
		# expect( page ).to have_title( full_title( 'About Us' ) )
		click_link _t('static_pages.help.title')
		expect( page ).to have_title( full_title( _t('static_pages.help.title') ) )
		# click_link t('w.contact')
		# expect( page ).to have_title( full_title( 'Contact' ) )
		# click_link t('w.home')	# 一度ホームに移動
		# click_link t('w.signout')
		# expect( page ).to have_title( full_title( 'Sign up' ) )
		click_link t('app.title')
	end
end
