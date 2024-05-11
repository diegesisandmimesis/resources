#charset "us-ascii"
//
// resources.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

// Module ID for the library
resourcesModuleID: ModuleID {
        name = 'Resources Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

class Resources: Thing
	resourcesObjectClass = ResourcesObject

	resourcesCollectiveClass = ResourcesCollective
	resourcesListClass = ResourcesList
	resourcesReportManagerClass = ResourcesReportManager

	resourcesCollective = nil
	resourcesList = nil
	resourcesReportManager = nil

	dispenseTo = nil

	getResourcesCollective() {
		if(resourcesCollective == nil) {
			resourcesCollective = resourcesCollectiveClass
				.createInstance();

			resourcesCollective.resources = self;
			resourcesCollective.initResourcesCollective();
		}
		return(resourcesCollective);
	}

	getResourcesList() {
		if(resourcesList == nil)
			resourcesList = resourcesListClass.createInstance();
		return(resourcesList);
	}

	getResourcesReportManager() {
		if(resourcesReportManagerClass == nil)
			return(nil);
		if(resourcesReportManager == nil) {
			resourcesReportManager = resourcesReportManagerClass
				.createInstance();
			resourcesReportManager.resources = self;
		}
		return(resourcesReportManager);
	}

	dispenseObject() {
		local obj;

		obj = resourcesObjectClass.createInstance();
		obj.resources = self;
		obj.initResourcesObject();

		if(dispenseTo != nil)
			obj.moveInto(dispenseTo);

		return(obj);
	}

	getReportObjects() {
		local m;

		if((m = getResourcesReportManager()) == nil)
			return(nil);
		return(m.getReportObjects());
	}

	summarizeExamines(txt) {
		local o;

		if(((o = getReportObjects()) == nil)
			|| (o.length < 1)) {
			txt.append(libMessages.resourcesSummaryFailed());
			return;
		}
		txt.append(libMessages.resourcesSummarizeExamine(o.length,
			o[1]));
	}
;

class ResourcesList: ListGroupEquivalent;

class ResourcesCollective: CollectiveGroup
	isPlural = true

	resources = nil

	resourcesKludge = nil

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
			resourcesKludge = reqNum;
		}
	}

	filterResolveList(lst, action, whichObj, np, reqNum) {
		resourcesKludge = nil;

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

	initResourcesCollective() {
		local cls;

		if(resources == nil)
			return;

		if((cls = resources.resourcesObjectClass) == nil)
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

class ResourcesReportManager: ReportManager
	resources = nil

	reportManagerActions = static [ ExamineAction ]

	checkReport(x) {
		return((x.dobj_ != nil)
			&& (x.dobj_.ofKind(resources.resourcesObjectClass)));
	}

	summarizeReport(act, vec, txt) {
		if(act.ofKind(ExamineAction))
			summarizeExamines(txt);
	}

	summarizeExamines(txt) { resources.summarizeExamines(txt); }
;
