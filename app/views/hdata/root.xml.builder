xml.instruct!
xml.hcp('name' => "Distributed Query",  'id' => "http://projecthquery.org/distributedquery",
        'xmlns' => "http://projecthdata.org/hdata/schemas/2010/04/hcp",
        'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
        'xsi:schemaLocation' => "http://projecthdata.org/hdata/schemas/2010/04/hcp http://github.com/projecthdata/hData/raw/master/schemas/2010/04/hcp.xsd",
        'xmlns:core' => "http://projecthdata.org/hdata/schemas/2009/06/core") do
  xml.core :extensions do
    xml.core(:extension, 'extensionId' => 'http://projecthquery.org/distributedquery/query')
    xml.core(:extension, 'extensionId' => 'http://projecthquery.org/distributedquery/result')
  end
  xml.core :sections do
    xml.core(:section, 'path' => 'queries', 'extensionId' => 'http://projecthquery.org/distributedquery/query',
                       'name' => 'Distributed Queries')
    xml.core(:section, 'path' => 'results', 'extensionId' => 'http://projecthquery.org/distributedquery/result',
                       'name' => 'Query Results')
  end
end
