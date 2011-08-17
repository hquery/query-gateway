xml.instruct!
xml.feed('xmlns' => 'http://www.w3.org/2005/Atom') do
  xml.title 'hData Record Sections'
  xml.link('href' => hdata_index_url)
  xml.updated [Result.last_result_saved, Query.last_query_update].max.xmlschema
  xml.author do
    xml.name 'hQuery Gateway'
  end
  xml.id hdata_index_url
  
  xml.entry do
    xml.title 'Query Results'
    xml.link('href' => '/results')
    xml.id results_url
    xml.updated Result.last_result_saved.xmlschema
    xml.summary 'Results of hQueries'
  end
  
  xml.entry do
    xml.title 'Distributed Queries'
    xml.link('href' => '/queries')
    xml.id queries_url
    xml.updated Query.last_query_update.xmlschema
    xml.summary 'hQueries'
  end
end