#charset "us-ascii"
//
// resourceCollective.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceList: ListGroupEquivalent;

class ResourceCollective: CollectiveGroup
	// Our parent Resource instance.
	resourceFactory = nil

	isPlural = true

	resourceKludge = nil

	isCollectiveAction(action, whichObj) { return(true); }

	isCollectiveQuant(np, reqNum) {
		return((reqNum == nil) || (reqNum > 1));
	}

	filterResolveListCount(lst, reqNum) {
		local len, vis;

		if((vis = gActor.visibleInfoTable()) == nil)
			return;

		len = 0;
		vis.forEachAssoc(function(key, val) {
			if(key.hasCollectiveGroup(self)
				&& (key.getCarryingActor() == gActor)) {
					len += 1;
			}
		});

/*
		if(reqNum == nil)
			reqNum = len;
*/

		if(reqNum <= len) {
			lst.forEach(function(o) {
				if(o.obj_ == self)
					o.quant_ = reqNum;
			});
			resourceKludge = reqNum;
		}
	}

	filterResolveList(lst, action, whichObj, np, reqNum) {
		resourceKludge = nil;

		if(isCollectiveQuant(np, reqNum)
			&& isCollectiveAction(action, whichObj)) {
			lst = lst.subset({
				x: !x.obj_.hasCollectiveGroup(self)
			});
			filterResolveListCount(lst, reqNum);
		} else if(lst.indexWhich({
			x: x.obj_.hasCollectiveGroup(self) }) != nil) {
			lst = lst.removeElementAt(lst.indexWhich({
				x: x.obj_ == self
			}));
		}

		return(lst);
	}

	initResourceCollective() {
		local cls;

		if(resourceFactory == nil)
			return;

		if((cls = resourceFactory.resourceClass) == nil)
			return;

		borrowFromDictionary(cls, &noun);
		borrowFromDictionary(cls, &adjective);
		borrowFromDictionary(cls, &plural);
	}

	borrowFromDictionary(cls, prop) {
		if(cls.(prop) != nil)
			cmdDict.addWord(self, cls.(prop), prop);
	}
;
