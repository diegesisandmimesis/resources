#charset "us-ascii"
//
// resourceSummary.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceSenseSummary: ReportSummary
	_summarizeDesc(vec, txt, prop) {
		local o;

		if((vec == nil) || vec.length < 1)
			return;

		o = vec[1].dobj_;

		o._resourceSummary = true;
		txt.append(mainOutputStream.captureOutput({: "<<o.(prop)>>" }));
		o._resourceSummary = nil;
	}
;

class ResourceExamineSummary: ResourceSenseSummary
	action = ExamineAction
	summarize(vec, txt) { _summarizeDesc(vec, txt, &desc); }
;

class ResourceSmellSummary: ResourceSenseSummary
	action = SmellAction
	summarize(vec, txt) { _summarizeDesc(vec, txt, &smellDesc); }
;

class ResourceSoundSummary: ResourceSenseSummary
	action = ListenToAction
	summarize(vec, txt) { _summarizeDesc(vec, txt, &soundDesc); }
;

class ResourceFeelSummary: ResourceSenseSummary
	action = FeelAction
	summarize(vec, txt) { _summarizeDesc(vec, txt, &feelDesc); }
;

class ResourceTasteSummary: ResourceSenseSummary
	action = TasteAction
	summarize(vec, txt) { _summarizeDesc(vec, txt, &tasteDesc); }
;
