### Description
This is effectively a [poolparty](http://auser.github.com/poolparty/) template that can easily spawn a [Cassandra](http://cassandra.apache.org/) (8.x or 7.x) or [Brisk](http://www.datastax.com/products/brisk) cluster on [Amazon's EC2](http://aws.amazon.com/ec2/). Additionaly, it can easily install [OpsCenter](http://www.datastax.com/products/opscenter) when provided with OpsCenter credentials. Most of the heavy lifting is done by the [DataStax EC2 AMI](https://github.com/riptano/ComboAMI) and [poolparty](https://github.com/auser/poolparty).

### Prereqs: EC2 Setup 
Add your AWS Info to ~/.profile or ~/.bashrc:

    export EC2_URL="https://<region>.ec2.amazonaws.com/" # (e.g. region: us-west-1)
    export EC2_ACCESS_KEY="AAAAAAAAAABBBBBB"
    export EC2_SECRET_KEY="NRLSKDM@$@$/4@$%%NNNSN"
    export EC2_PRIVATE_KEY="/path/to/pk-XXX.pem"
    export EC2_CERT="/path/to/cert-XXX.pem"

Also make sure to generate a [keypair](http://docs.amazonwebservices.com/AWSEC2/latest/CommandLineReference/index.html?ApiReference-cmd-CreateKeyPair.html) to use for ssh access.

For more details see [poolparty's setup guide](http://auser.github.com/poolparty/amazon_ec2_setup.html)

### Download
    git clone git://github.com/fuentesjr/cassies-party.git
    cd cassies-party
    bundle install --binstubs
    # vim config.yml ... edit, edit, etc.
    # make sure to specify your ec2 ssh key (keypair) in config.yml otherwise 
    # you won't be able to ssh in. The ec2login default would look for:
    # ~/.ssh/ec2login.pem
    bin/cloud start -c ./clouds.rb
    bin/cloud ssh -c ./clouds.rb # Wait 5-10minutes afer this while the instance finalizes

Then have at it! 


### Resources

1. [Great info when running on EC2](http://www.slideshare.net/mattdennis/cassandra-on-ec2)
2. [Spawn cluster with DataStax AMI](http://www.datastax.com/dev/blog/setting-up-a-cassandra-cluster-with-the-datastax-ami)
3. [Cassandra Cloud Wiki](http://wiki.apache.org/cassandra/CloudConfig)

### MIT License

Copyright (c) 2011 Salvador Fuentes Jr.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
