module ResultsHelper
  # Calling result.to_json produces JSON all on a single line
  # Passing a result to JSON.pretty_generate raises an exception
  # This method generates the terse JSON, parses it, and then
  # pretty generates it. I realize how silly this is.
  def pretty_json(result)
	JSON.pretty_generate(JSON.parse(result.to_json))
  end
end
