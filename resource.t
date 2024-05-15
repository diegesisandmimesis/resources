#charset "us-ascii"
//
// resource.t
//
//	A TADS3/adv3 for implementing indistinguishable, interchangeable
//	resource objects (wood, stone, coins, and so on).
//
//	The module takes care of a few common tasks associated with
//	coding these kinds of objects in adv3:
//
//		-Creating and assigning a CollectiveGroup
//		-Creating and assigning a ListGroupEquivalent
//		-Creating and assigning a report manager to merge
//			multiple reports
//
//	In addition it provides some message parameter substitutions to
//	work with equivalent objects singly or in groups:
//
//		{single/plural resource}
//			replaced with the resource's name or plural name
//			as appropriate
//
//		{count resource}
//			replaced with the number of matching resource
//			objects spelled out ("one", "two", "three", and so
//			on
//
//		{a/count resource}
//			replaced with "a" if there's one matching resource
//			or the count ("five", "fifteen", or whatever) if
//			there are more
//
//	These are designed to be used in conjunction with report summaries,
//	including the implicit sense-related summaries included with the
//	module.  They summarize >EXAMINE, >SMELL, >LISTEN TO, >FEEL,
//	and >TASTE actions on the resource.  See the examples below for
//	more information.
//
//
// USAGE
//
//	First, declare a factory object for the resource.  It's the container
//	for the various other bits that handle things:
//
//		// Declare a resource factory for the Pebble resource
//		ResourceFactory
//			resourceClass = Pebble
//		;
//
//		// Declare the resource
//		class Pebble: Resource
//			'(small) (round) pebble*pebbles' 'pebble'
//
//			"\^{A/Count resource} small, round
//			{single/plural resource}. "
//
//			smellDesc = "It smells like {a/count resource} small,
//				round {single/plural resource}. "
//
//		;
//
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

// This is used for a kludge to workaround how adv3 handles sense
// descriptions (in their own reports).
modify Thing
	_resourceSummary = nil
;

class Resource: ResourceMessageParams, Thing
	resourceFactory = nil

	isEquivalent = true

	// The soundDesc and smellDesc properties by default handle
	// output by generating an report, via defaultDescReport.
	// If we're calling the properties because we're in the middle
	// of summarizing reports we really don't want that to happen,
	// so we manually output the same message, letting the
	// caller (ResourceSenseSummary._summarizeDesc()) to capture
	// the output to add to the summary.
	// If either property is overwritten via something like:
	//
	//	soundDesc = "It smells like {a/count resource}
	//		{single/plural resource}. "
	//
	// This will work fine because we'll have no trouble capturing
	// a double-quoted string.
	soundDesc() {
		if(_resourceSummary != true) {
			inherited();
			return;
		}
		"<<gActor.getActionMessageObj().thingSoundDescMsg(self)>> ";
	}

	smellDesc() {
		if(_resourceSummary != true) {
			inherited();
			return;
		}
		"<<gActor.getActionMessageObj().thingSmellDescMsg(self)>> ";
	}

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
		local d, l;

		if((d = getResourceFactory()) == nil)
			return;

		l = d.getResourceCollective();
		if(collectiveGroups.indexOf(l) == nil)
			collectiveGroups += l;

		l = d.getResourceList();
		if(listWith.indexOf(l) == nil)
			listWith += l;

		if(reportManager == nil)
			reportManager = d.getResourceReportManager();
	}
;
