### Bootstrap, install and configure ElasticSearch with Chef Solo on an Ubuntu EC2 server

This is an adaptation of the great tutorial [deploying elasticsearch with chef solo](http://www.elasticsearch.org/tutorials/deploying-elasticsearch-with-chef-solo/) written by Karel Minařík which aims to works on Ubuntu based servers.


It's a simple Rake task that launches an EC2 AMI based on Ubuntu.
It currently uses the Ubuntu 12.04 TLS (ami-d0f89fb9), but it should work with other Ubuntu version/AMI.
A 25gb EBS is attached to the AMI.

It basically installs and configures Elasticsearch through Chef-solo recipes.
Elasticsearch is monitored by Monit and Nginx is used as a proxy.

#### USAGE

Add a node.json file
```shell
mv node.json.example node.json
```

Add your AWS and NGINX credentials and your contact email for Monit. (search and replace the term "YOUR_" in the node.json file)

Copy your AWS SSH Key into the tmp directory

Finally launch the rake task
```shell
bundle install
bundle exec rake create NAME=elastisearch-01
```

#### TESTING

Add some shell variables
```shell
USERNAME=YOUR_NGINX_USERNAME
PASSWORD=YOUR_NGINX_PASSWORD
HOST=YOUR_AWS_HOST
```

```shell
curl http://$USERNAME:$PASSWORD@$HOST:8080
```
Should returns something like this:
```json
{
  "ok" : true,
  "status" : 200,
  "name" : "elasticsearch-2",
  "version" : {
    "number" : "0.90.3",
    "build_hash" : "5c38d6076448b899d758f29443329571e2522410",
    "build_timestamp" : "2013-08-06T13:18:31Z",
    "build_snapshot" : false,
    "lucene_version" : "4.4"
  },
  "tagline" : "You Know, for Search"
}
```

Anyway, we can index some documents through the proxy just fine:
```shell
curl -X POST "http://$USERNAME:$PASSWORD@$HOST:8080/test_chef_cookbook/document/1" -d '{"title" : "Test 1"}'
curl -X POST "http://$USERNAME:$PASSWORD@$HOST:8080/test_chef_cookbook/document/2" -d '{"title" : "Test 2"}'
curl -X POST "http://$USERNAME:$PASSWORD@$HOST:8080/test_chef_cookbook/document/3" -d '{"title" : "Test 3"}'
curl -X POST "http://$USERNAME:$PASSWORD@$HOST:8080/test_chef_cookbook/_refresh"
```

Let’s try to perform a search:
```shell
curl "http://$USERNAME:$PASSWORD@$HOST:8080/_search?pretty"
```

Launch another machine
```shell
bundle exec rake create NAME=elastisearch-02
```

In a browser open:
```
http://$USERNAME:$PASSWORD@$HOST:8080/_plugin/paramedic/
```

There should be 2 nodes now ! Hurrah !

#### Authors

Original code by Karel Minařík [@karmi](https://github.com/karmi)

Upgraded and adapted for Ubuntu by:
* Louis Cuny: [@lou](https://github.com/lou)
* Olivier de Robert: [@zitooon](https://github.com/zitooon)

### License

Licensed under [MIT](http://opensource.org/licenses/mit-license.php). Enjoy!
