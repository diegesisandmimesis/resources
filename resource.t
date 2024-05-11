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
	resourceObjectClass = ResourceObject

	resourceCollectiveClass = ResourceCollective
	resourceListClass = ResourceList
	resourceReportManagerClass = ResourceReportManager

	resourceCollective = nil
	resourceList = nil
	resourceReportManager = nil

	dispenseTo = nil

	getResourceCollective() {
		if(resourceCollective == nil) {
			resourceCollective = resourceCollectiveClass
				.createInstance();

			resourceCollective.resource = self;
			resourceCollective.initResourceCollective();
		}
		return(resourceCollective);
	}

	getResourceList() {
		if(resourceList == nil)
			resourceList = resourceListClass.createInstance();
		return(resourceList);
	}

	getResourceReportManager() {
		if(resourceReportManagerClass == nil)
			return(nil);
		if(resourceReportManager == nil) {
			resourceReportManager = resourceReportManagerClass
				.createInstance();
			resourceReportManager.resource = self;
		}
		return(resourceReportManager);
	}

	dispenseObject() {
		local obj;

		obj = resourceObjectClass.createInstance();
		obj.resource = self;
		obj.initResourceObject();

		if(dispenseTo != nil)
			obj.moveInto(dispenseTo);

		return(obj);
	}

	getReportObjects() {
		local m;

		if((m = getResourceReportManager()) == nil)
			return(nil);
		return(m.getReportObjects());
	}

	summarizeExamines(txt) {
		local o;

		if(((o = getReportObjects()) == nil)
			|| (o.length < 1)) {
			txt.append(libMessages.resourceSummaryFailed());
			return;
		}
		txt.append(libMessages.resourceSummarizeExamine(o.length,
			o[1]));
	}
;

class ResourceList: ListGroupEquivalent;

class ResourceCollective: CollectiveGroup
	isPlural = true

	resource = nil

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

		if(reqNum == nil)
			reqNum = len;

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

		if(resource == nil)
			return;

		if((cls = resource.resourceObjectClass) == nil)
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

class ResourceReportManager: ReportManager
	resource = nil

	reportManagerActions = static [ ExamineAction ]

	checkReport(x) {
		return((x.dobj_ != nil)
			&& (x.dobj_.ofKind(resource.resourceObjectClass)));
	}

	summarizeReport(act, vec, txt) {
		if(act.ofKind(ExamineAction))
			summarizeExamines(txt);
	}

	summarizeExamines(txt) { resource.summarizeExamines(txt); }
;
