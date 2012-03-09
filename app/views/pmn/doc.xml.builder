xml.instruct!
xml.ResponseDocumentResponse('xmlns' => 'http://lincolnpeak.com/schemas/DNS4/API') do
  xml.ResponseDocumentResult @doc.length
  xml.Data Base64.encode64(@doc)
end