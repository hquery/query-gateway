require 'query_job'
require 'java_query_executor'

QueryJob.const_set(:QueryExecutor , JavaQueryExecutor)

