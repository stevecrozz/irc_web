# ForceOmniAuthLogin is a Rack middleware that forces users to login using
# omniauth before being allowed to proceed to the actual application
class ForceOmniAuthLogin
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] == '/auth/login'
      # OmniAuth handles this business, so pass it through
      @app.call(env)
    elsif env['PATH_INFO'] == '/auth/login/callback'
      # Calling back, save that auth data to the session and redirect to /
      env['rack.session']['omniauth.auth'] = env['omniauth.auth']
      [ 302, { 'Location' => '/', 'Content-Type' => 'text/html' }, [] ]
    elsif env['rack.session'] && env['rack.session']['omniauth.auth']
      # any other URL and we do have auth
      @app.call(env)
    else
      # any other URL and we have no auth
      [ 302, { 'Location' => '/auth/login', 'Content-Type' => 'text/html' }, [] ]
    end

  end
end
