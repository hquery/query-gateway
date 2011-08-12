xml.instruct!
xml.feed('xmlns' => 'http://www.w3.org/2005/Atom') do
  xml.title 'hData Record Sections'
  xml.link('href' => hdata_index_url)
  xml.updated Time.new(2011, 8, 12).xmlschema #TODO: Update when query or results change
  xml.author do
    xml.name 'hQuery Gateway'
  end
  xml.id hdata_index_url
  
  xml.entry do
    xml.title 'Query Results'
    xml.link('href' => '/results')
    xml.id 'http://projecthquery.org/results' #TODO: Update when results are implemented
    xml.updated Time.new(2011, 8, 12).xmlschema #TODO: Update when results change
    xml.summary 'Results of hQueries'
  end
  
  xml.entry do
    xml.title 'Distributed Queries'
    xml.link('href' => '/queries')
    xml.id 'http://projecthquery.org/queries' #TODO: Update when results are implemented
    xml.updated Time.new(2011, 8, 12).xmlschema #TODO: Update when results change
    xml.summary 'hQueries'
  end
end