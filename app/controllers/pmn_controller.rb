require 'webrick'

class PmnController < ApplicationController
  before_filter :patch_accept
  
  def patch_accept
    request.format = 'xml' unless params[:format]
  end

  # IModelProcessorService::PostRequest
  def create
    doc = parse_request_body
    
    # find the ids and types of the query documents of interest (either HQMF or native JS)
    @doc_ids = doc.xpath('//pmn:Document').collect do |entry|
      mime_type = entry.at_xpath('./pmn:MimeType').inner_text
      doc_id = entry.at_xpath('./pmn:DocumentId').inner_text
      doc_size = entry.at_xpath('./pmn:Size').inner_text.to_i
      if mime_type && (mime_type =~ /^(multipart\/form-data)|(application\/xml)/)
        {:doc_id => doc_id, :mime_type => mime_type, :size => doc_size}
      else
        nil
      end
    end
    @doc_ids.compact!
    
    # create a new PMNRequest -- we only accept one query document per request
    # per request, either HQMF or multipart/form-data
    request = PMNRequest.new(@doc_ids[0])
    request.save!
    @id = request.id
    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::PostRequestDocument
  def add
    request = PMNRequest.find(params[:id])
    
    if params[:doc_id] == request.doc_id
      doc = parse_request_body
      base64_data = doc.at_xpath('//pmn:Data').inner_text
      request.content ||= ''
      request.content << Base64.decode64(base64_data)
      request.save!
    end

    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::Start
  def start
    request = PMNRequest.find(params[:id])
    
    map = reduce = functions = nil
    
    if request.mime_type =~ /^multipart\/form-data/
      query_hash = parse_form_data(request)
      map = query_hash['map']
      reduce = query_hash['reduce']
      functions = query_hash['functions']
    else # HQMF
      query_hash = HQMF2JS::Converter.generate_map_reduce(request.content)
      map = query_hash[:map]
      reduce = query_hash[:reduce]
      functions = query_hash[:functions]
    end

    # Create a new query and execute it
    request.build_query(:map => map, :reduce => reduce, :functions=>functions)
    request.save!
    request.query.save!
    request.query.job
    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::Stop
  def stop
    request = PMNRequest.find(params[:id])
    # just ignore this for now
    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::GetStatus
  def status
    request = PMNRequest.find(params[:id])
    query_status = request.query.nil? ? :queued : request.query.status
    @status = case query_status
      when :running then 'InProgress'
      when :failed then 'Error'
      when :queued then 'Pending'
      when :error then 'Error'
      when :complete then 'Complete'
      when :cancelled then 'Cancelled'
      else 'Pending'
    end
    @message = request.query.nil? ? 'Waiting for query docs' : request.query.job_logs.last.message
    
    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::GetResponse
  def get_response
    request = PMNRequest.find(params[:id])
    
    @doc = request.query.result.to_json
    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::GetResponseDocument
  def doc
    request = PMNRequest.find(params[:id])
    offset = params[:offset].to_i
    
    @doc = request.query.result.to_json[offset..-1]
    respond_to do |format|
      format.xml
    end
  end
  
  # IModelProcessorService::Close
  def close
    # just ignore this for now
    respond_to do |format|
      format.xml
    end
  end
  
  private
  
  def parse_request_body
    xml_file = request.body
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('pmn', 'http://lincolnpeak.com/schemas/DNS4/API')
    doc
  end
  
  def parse_form_data(request)
    http_request = "POST /path HTTP/1.1\r\n"
    http_request << "Content-Type: #{request.mime_type}\r\n"
    http_request << "Content-Length: #{request.content.length}\r\n\r\n"
    http_request << request.content
    
    parser = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
    parser.parse(StringIO.new(http_request))
    
    parser.query
  end
  
end
