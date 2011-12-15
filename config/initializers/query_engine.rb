require 'query_job'
require 'mongo_query_executor'

QueryJob.const_set(:QueryExecutor , MongoQueryExecutor)

