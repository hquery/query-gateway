xml.instruct!
xml.feed('xmlns' => 'http://www.w3.org/2005/Atom', 'xmlns:md' => 'http://projecthdata.org/hdata/schemas/2009/11/metadata') do
  xml.title 'Distributed Queries'
  xml.link('href' => hdata_index_url)
  xml.updated Time.new(2011, 8, 12).xmlschema #TODO: Update when query or results change
  xml.author do
    xml.name 'hQuery Gateway'
  end
  xml.id queries_url
  
  @queries.each do |query|
    xml.entry do
      xml.title 'Query Result'
      xml.content('type' => 'xml') do
        xml.md :DocumentMetadata do
          xml.md(:DocumentId, query_url(query))
          xml.md(:Title, 'Query Result')
          xml.md :RecordDate do
            xml.md(:CreatedDateTime, query.created_at.xmlschema)
            if query.has_been_updated?
              xml.md :Modified do
                xml.md(:ModifiedDateTime, query.updated_at.xmlschema)
              end
            end
          end
        end
      end
      xml.link('href' => query_url(query))
      xml.id query_url(query)
      xml.updated query.updated_at.xmlschema
    end
  end
end