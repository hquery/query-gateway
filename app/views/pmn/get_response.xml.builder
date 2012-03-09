xml.instruct!
xml.ResponseResponse('xmlns' => 'http://lincolnpeak.com/schemas/DNS4/API') do
  xml.ResponseResult do
    xml.Document do
      xml.DocumentId 'result'
      xml.Filename 'result.json'
      xml.MimeType 'application/json'
      xml.Size @doc.length
      xml.Viewable 'false'
    end
  end
end