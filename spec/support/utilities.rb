include ApplicationHelper

# I18n macros
def _t( key, options={} )
  I18n.t( key, options )
end

def t( key, options={} )
  @tes = [] if nil == @tes
  if @tes.length > 0
    I18n.t( @tes.last + key, options )
  else
    I18n.t( key, options )
  end
end

def t_push( path )
  @tes = [] if nil == @tes
  @tes.push( path )
end

def t_pop()
  @tes = [] if nil == @tes
  @tes.pop
end

RSpec::Matchers.define :have_welcome_message do |message|
	match do |page|
		expect( page ).to have_selector( 'div.alert.alert-success', text: message )
	end
end

def sign_in( user, options={} )
  if options[ :no_capybara ]
    # Capybaraを使用していない場合にもサインインする。
    # remember_token = User.new_remember_token
    # cookies[ :remember_token ] = remember_token
    # user.update_attribute( :remember_token, User.encrypt( remember_token ) )
  else
    t_push 'sessions.new'
    visit signin_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button t('.submit')
    t_pop
  end
end
