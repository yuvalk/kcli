## Architecture

### On libvirt/ovirt/vsphere/kubevirt/openstack

We deploy :

- an arbitrary number of masters.
- an arbitrary number of workers.
- a bootstrap node removed during the install.
- on kubevirt/openstack/vsphere, an additional bootstrap helper node removed during the install. It serves ignition data to the bootstrap node, as the field used to store userdata can't handle the many characters of the bootstrap ignition file.

If oc or openshift-install are missing, latest versions are downloaded on the fly, either from registry.svc.ci.openshift.org if ci is specified (the provided pull secret needs an auth for this registry) or using public mirrors otherwise.

If no image is specified in a parameters file, latest rhcos image is downloaded and the corresponding line is added in the parameter file.

All the ignition files needed for the install are generated.

Deployment of masters and bootstrap is then launched.

Keepalived and Coredns with mdns are created on the fly on the bootstrap and master nodes as static pods. Initially, the api vip runs on the bootstrap node.

Nginx is created as static pod on the bootstrap node to serve as a http only web server for some additional ignition files needed on the nodes and which can't get injected (they are generated on the bootstrap node).

Haproxy is created as static pod on the master nodes to load balance traffic to the routers. When there are no workers, routers are instead scheduled on the master nodes and the haproxy static pod isn't created, so routers are simply accessed through the vip without load balancing in this case.

Once bootstrap steps finished, the corresponding vm gets deleted, causing keepalived to migrate the vips to one of the masters.

At this point, workers are created.

Also note that for bootstrap, masters and workers nodes, we merge the ignition data generated by the openshift installer with the ones generated by kcli, in particular we prepend dns server on those nodes to point to our keepalived vip, force hostnames and inject static pods.

### On aws/gcp

On those platform, We rely on dns.

For aws, you can use the rhcos-* ami images

For gcp, you will need to get the rhcos image, move it to a google bucket and import the image

An extra temporary node is deployed to serve ignition data to the bootstrap node, as those platforms use userdata field to pass ignition, and the bootstrap has too many characters.

Additionally, we automatically create the following dns records:

- api.$cluster.$domain initially pointing to the public ip of the bootstrap node, and later on changed to point to the public ip of the first master node
- *.apps.$cluster.$domain pointing to the public ip of the first master node ( or the first worker node if present)
- etcd-$num and default fqdn entries pointing to the private ip for the corresponding masters
- the proper srv dns entries.