#charset "us-ascii"
//
// resource.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

// Module ID for the library
resourceModuleID: ModuleID {
        name = 'Resource Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

class Resource: Thing
	isEquivalent = true

	resourceFactory = nil

	initializeThing() {
		inherited();
		initResource();
	}

	getResourceFactory() {
		if(resourceFactory == nil)
			findResourceFactory();
		return(resourceFactory);
	}

	findResourceFactory() {
		forEachInstance(ResourceFactory, function(o) {
			if(self.ofKind(o.resourceClass))
				resourceFactory = o;
		});
	}

	initResource() {
		local d;

		if((d = getResourceFactory()) == nil)
			return;

		if(collectiveGroups.length == 0)
			collectiveGroups += d.getResourceCollective();
		if(listWith.length == 0)
			listWith += d.getResourceList();

		if(reportManager == nil)
			reportManager = d.getResourceReportManager();
	}
;
