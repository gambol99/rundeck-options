
Rundeck Options
---------------

A small [http://rundeck.org/][1] integration piece; the sinatra app provides a simple API which is consumed by rundeck jobs - provides items such as images, flavors, free floating ip addresses, keyspair, security groups etc

----------

Example Configuration: 
--------------
../config/settings.yml

    port: 8081
    bind: 127.0.0.1
    openstack:
      :username: admin
      :tenant: admin
      :api_key: mypassword
      :auth_url: http://horizon.domain.com:5000/v2.0/tokens 


----------


Rundeck Job Example
-------------------
  
      group: openstack
      options:
        compute:
          description: the compute host you wish to run the instance
          valuesUrl: http://rundeck_options.local/computes
        flavor:
          required: true
          description: The openstack flavor to use
          value: 1core-2048mem-10gb
          valuesUrl: http://rundeck_options.local/flavors
        hostname:
          required: true
          description: The hostname of the instance
        image:
          required: true
          description: The image to use within openstack
          value: centos-base-6.5-min-07-05-2014
          valuesUrl: http://rundeck_options.local/images
        keypair:
          required: true
          description: the keypair you wish to assign to the image
          value: default
          valuesUrl: http://rundeck_options.local/keypairs
        networks:
          required: true
          description: a list of networks to assign
          value: private_net
          valuesUrl: http://rundeck_options.local/networks
        stack:
          required: true
          description: the openstack cluster you are deploying to
          value: qa


  [1]: http://rundeck.org/
