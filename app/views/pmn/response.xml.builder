xml.instruct!
xml.ResponseResponse('xmlns' => 'http://lincolnpeak.com/schemas/DNS4/API') do
  xml.ResponseResult do
    xml.Document do
      xml.DocumentId 'result'
      xml.Filename 'result.json'
      xml.Viewable 'false'
      xml.MimeType 'application/json'
      xml.size @doc.length
    end
  end
end