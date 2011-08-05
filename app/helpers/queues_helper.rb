require 'coderay/encoders/html'
module QueuesHelper
  
  def format_javascript(js)
    tokens = CodeRay.scan js, :javascript
    tokens.html :line_numbers => :list, :wrap => nil
  end
  
  def code_ray_style
    %{
    #{CodeRay::Encoders::HTML::CSS.load_stylesheet::CSS_MAIN_STYLES}   
    #{ CodeRay::Encoders::HTML::CSS.load_stylesheet::TOKEN_COLORS}
    }
  end
end
