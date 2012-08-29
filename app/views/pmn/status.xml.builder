xml.instruct!
xml.StatusResponse('xmlns' => 'http://lincolnpeak.com/schemas/DNS4/API') do
  xml.StatusResult do
    xml.Code @status
    xml.Message @message
  end
end