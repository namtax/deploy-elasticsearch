### Bootstrap, install and configure ElasticSearch with Chef Solo on an Ubuntu EC2 server

This is an adaptation of the great tutorial [deploying elasticsearch with chef solo](http://www.elasticsearch.org/tutorials/deploying-elasticsearch-with-chef-solo/) written by Karel Minařík.

It's a simple Rake task that launches an EC2 Instance based on Ubuntu.
It currently uses the Ubuntu 12.04 LTS (ami-d0f89fb9), but it should work with other Ubuntu version/AMI.
A 25gb EBS volume is attached to the AMI to store the Elasticsearch indexes (size is configurable).

It basically installs and configures Elasticsearch through Chef-solo recipes.
Elasticsearch is monitored by Monit and Nginx is used as a proxy.

#### USAGE

Add a node.json file
```shell
cp node.json.example node.json
```

Add your AWS and NGINX credentials, your EC2 security group and your contact email for Monit (search and replace the term "YOUR_" in the node.json file).

Install gems
```shell
bundle install
```

Finally launch the rake task, don't forget to add a NAME for the ES node, AWS_SSH_KEY_ID which is the name of your AWS Key Pair and SSH_KEY which is the local path to your Key Pair 
```shell
bundle exec rake create NAME=elastisearch-01 AWS_SSH_KEY_ID=aws_key_pair_name SSH_KEY=path/to/aws_key_pair
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

Launch another machine:
```shell
bundle exec rake create NAME=elastisearch-02
```

In a browser open:
```
http://$USERNAME:$PASSWORD@$HOST:8080/_plugin/paramedic/
```
With the EC2 autodiscovery function from elasticsearch, these 2 servers (and thus 2 nodes) are now working together. Hurrah !

#### Authors

Original code and tutorial by Karel Minařík [@karmi](https://github.com/karmi)

Upgraded and adapted for Ubuntu by:
* Louis Cuny: [@lou](https://github.com/lou)
* Olivier de Robert: [@zitooon](https://github.com/zitooon)

### License

Licensed under [MIT](http://opensource.org/licenses/mit-license.php). Enjoy!
