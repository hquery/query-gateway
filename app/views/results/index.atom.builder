xml.instruct!
xml.feed('xmlns' => 'http://www.w3.org/2005/Atom', 'xmlns:md' => 'http://projecthdata.org/hdata/schemas/2009/11/metadata') do
  xml.title 'Distributed Queries'
  xml.link('href' => hdata_index_url)
  xml.updated Time.new(2011, 8, 12).xmlschema #TODO: Update when query or results change
  xml.author do
    xml.name 'hQuery Gateway'
  end
  xml.id results_url
  
  @results.each do |result|
    xml.entry do
      xml.title 'Query Result'
      xml.content('type' => 'xml') do
        xml.md :DocumentMetadata do
          xml.md(:DocumentId, result_url(result))
          xml.md(:Title, 'Query Result')
          xml.md :RecordDate do
            xml.md(:CreatedDateTime, result.created_at.xmlschema)
          end
        end
      end
      xml.link('href' => result_url(result))
      xml.id result_url(result)
      xml.updated result.created_at.xmlschema
    end
  end
end