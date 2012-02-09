xml.instruct!
xml.RequestResponse('xmlns' => 'http://lincolnpeak.com/schemas/DNS4/API') do
  xml.RequestResult @id
  xml.DesiredDocuments do
    @doc_ids.each do |doc|
      xml.string doc[:doc_id]
    end
  end
end