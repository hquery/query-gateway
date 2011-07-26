hQuery
=========

The query gateway is a web based application that provides the back end for executing queries. 

The query gateway which exposes a query API, accepts queries, runs those queries against the patient data,
and returns the results of the query back to the query composer.

Environments
------------
hQuery will run properly on OSX and various distributions of Linux

hQuery will also run on Windows, however, there are some minor limitations to functionality and performance.

Dependencies
------------
* Ruby = 1.9.2
* Rails 3.1
* MongoDB >= 1.8.1

Install Instructions
--------------------

See the query composer for installation instructions for both the composer and gateway
  http://github.com/hquery

License
-------

Copyright 2011 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Project Practices
-----------------

Please try to follow our [Coding Style Guides](http://github.com/eedrummer/styleguide). Additionally, we will be using git in a pattern similar to [Vincent Driessen's workflow](http://nvie.com/posts/a-successful-git-branching-model/). While feature branches are encouraged, they are not required to work on the project.