require 'test_helper'

class PmnControllerTest < ActionController::TestCase

  # post :create, {record_id: @record.medical_record_number, section: 'results'}

  setup do
    dump_database
  end
  
  def parse_response_body
    xml_file = @response.body
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('pmn', 'http://lincolnpeak.com/schemas/DNS4/API')
    doc.root.add_namespace_definition('ms', 'http://schemas.microsoft.com/2003/10/Serialization/Arrays')
    doc
  end

  test "should create a new PMN request" do
    query_summary = File.read(File.join(Rails.root, 'test', 'fixtures', 'pmn', 'post_request.xml'))
    @request.env['RAW_POST_DATA'] = query_summary
    @request.env['CONTENT_TYPE'] = 'application/xml'
    post :create
    assert_response :success
    assert_equal 'application/xml', @response.content_type
    doc = parse_response_body
    assert_equal 1, doc.xpath('count(//pmn:DesiredDocuments/ms:string)')
    assert_equal '1', doc.xpath('//pmn:DesiredDocuments/ms:string[1]').inner_text
    request_id = doc.at_xpath('//pmn:RequestResult').inner_text
    assert request_id
    r = PMNRequest.first(:conditions => {:doc_id => '1'})
    assert r
    assert_equal "multipart/form-data; boundary=-----------RubyMultipartPost", r.mime_type
    assert_equal nil, r.content
    
    add_doc = File.read(File.join(Rails.root, 'test', 'fixtures', 'pmn', 'add_document.xml'))
    @request.env['RAW_POST_DATA'] = add_doc
    @request.env['CONTENT_TYPE'] = 'application/xml'
    post :add, {id: request_id, doc_id: '1', offset: '0'}
    assert_response :success
    assert_equal 'application/xml', @response.content_type
    r.reload
    assert_equal "-------------RubyMultipartPost\r\nContent-Disposition: form-data; name=\"map\"; filename=\"local.path\"\r\nContent-Length: 56\r\nContent-Type: application/javascript\r\nContent-Transfer-Encoding: binary\r\n\r\nfunction map(patient) {\r\n  emit(patient.gender(), 1);\r\n}\r\n-------------RubyMultipartPost\r\nContent-Disposition: form-data; name=\"reduce\"; filename=\"local.path\"\r\nContent-Length: 123\r\nContent-Type: application/javascript\r\nContent-Transfer-Encoding: binary\r\n\r\nfunction reduce(gender, iter) {\r\n  var sum = 0;\r\n  while(iter.hasNext()) {\r\n    sum += iter.next();\r\n  }\r\n  return sum;\r\n};\r\n-------------RubyMultipartPost\r\nContent-Disposition: form-data; name=\"filter\"; filename=\"local.path\"\r\nContent-Length: 0\r\nContent-Type: application/json\r\nContent-Transfer-Encoding: binary\r\n\r\n\r\n-------------RubyMultipartPost\r\nContent-Disposition: form-data; name=\"functions\"; filename=\"local.path\"\r\nContent-Length: 0\r\nContent-Type: application/json\r\nContent-Transfer-Encoding: binary\r\n\r\n\r\n-------------RubyMultipartPost--\r\n\r\n", r.content
  end

end
