class QueriesController < ApplicationController
  def index   
    if stale?(:last_modified => Query.last_query_update.utc)
      Query.create_indexes  # ensures the indexes are created, does nothing if they already exist
      @queries = Query.desc(:updated_at)
      respond_to do |format|
        format.atom
        format.html
      end
    end
  end

  def create
    if params[:hqmf]
      codes_hash = nil
      if params[:codes]
        codes_path = params[:codes].tempfile.path
        code_parser = HQMF::ValueSet::Parser.new
        codes = code_parser.parse(codes_path, :format => HQMF::ValueSet::Parser.get_format(params[:codes].original_filename))
        codes_hash = HQMF2JS::Generator::CodesToJson.from_value_sets(codes)
      end
      doc = HQMF::Parser.parse(params[:hqmf], params[:version] || HQMF::Parser::HQMF_VERSION_2)
      map_reduce = HQMF2JS::Converter.generate_map_reduce(doc, codes_hash)
      map = map_reduce[:map]
      reduce = map_reduce[:reduce]
      functions = map_reduce[:functions]
    else
      map = params[:map].try(:read)
      reduce = params[:reduce].try(:read)
      functions = params[:functions].try(:read)
    end
      
    @query = Query.new(:map => map, :reduce => reduce, :functions=>functions)
    if params[:filter]
      @query.filter_from_json_string(params[:filter].read)
    end

    if @query.save
      response.headers["Location"] = query_url(@query)
      @query.job
      render :text => "Query Created", :status => 201
    else
      render :text => @query.errors.full_messages.join(','), :status => 400
    end
  end

  def show
    @query = Query.find(params[:id])
    if stale?(:last_modified => @query.updated_at.utc)
      @qh = @query.attributes
      @qh.delete('delayed_job_id')
      if @query.status == :complete and @query.result != nil
        @qh['result_url'] = result_url(@query.result)
      end
      respond_to do |format|
        format.json { render :json => @qh }
        format.html
      end
    end
  end
  
  def new
    @query = Query.new
  end
  
  def upload_hqmf
    hqmf_path = params[:query][:hqmf].tempfile.path
    hqmf_contents = File.open(hqmf_path).read
    codes_hash = nil
    if params[:query][:codes]
      codes_path = params[:query][:codes].tempfile.path
      code_parser = HQMF::ValueSet::Parser.new
      codes = code_parser.parse(codes_path, :format => HQMF::ValueSet::Parser.get_format(params[:query][:codes].original_filename))
      codes_hash = HQMF2JS::Generator::CodesToJson.from_value_sets(codes)
    end
    doc = HQMF::Parser.parse(hqmf_contents, params[:version] || HQMF::Parser::HQMF_VERSION_2, codes_hash)
    map_reduce = HQMF2JS::Converter.generate_map_reduce(doc, codes_hash)
    
    @query = Query.new(:format => 'hqmf', :map => map_reduce[:map], :reduce => map_reduce[:reduce], :functions => map_reduce[:functions])
    if @query.save
      response.headers["Location"] = query_url(@query)
      @query.job
    end
    
    redirect_to query_path(@query)
  end
end
