#charset "us-ascii"
//
// resourceMessageBuilder.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

// Make sure MessageBuilder calls us.
modify MessageBuilder
	execBeforeMe = (nilToList(inherited()) + [ resourceMessageBuilder ] )
;

// Random TADS3 lore:  a message parameter substitution tag can be no londer
//	than 13 characters.  If longer, it will silently fail (even if
//	otherwise correctly declared, the substitution won't happen and the
//	tag will be output instead).
resourceMessageBuilder: PreinitObject
	execute() {
		// Adds "single/plural", which will substitute for the
		// name or pluralName of the resource object.
		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append([
				'single/plural',
				&singleOrPluralName,
				'resource',
				nil,
				nil
			]);

		// Adds "count", which will substitute for the number
		// of resource objects mentioned in reports for this
		// action.
		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append([
				'count',
				&resourceCount,
				'resource',
				nil,
				nil
			]);

		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append([
				'a/count',
				&aOrResourceCount,
				'resource',
				nil,
				nil
			]);

		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append([
				'it/they',
				&itThey,
				'resource',
				nil,
				nil
			]);
	}
;

// Stub methods for base Thing class.  These are replaced by more useful
// stuff in the Resource class definition.
modify Thing
	singleOrPluralName() { return(name); }
	resourceCount() { return(toString(spellInt(1))); }
	aOrResourceCount() { return('a'); }
	itThey() { return('it'); }
;

// Handle some T3 bookkeeping.
// Discussion here:
// https://intfiction.org/t/message-parameter-substitution-in-room-names/58346/5
// Short version:  T3 message param substitution needs an object.  For our
// stuff we won't necessarily have a global object (like gDobj) to refer to,
// so we create a nameTable_ entry for our stuff that refers to either
// gDobj or gPlayerChar (if gDobj doesn't exist).
// Normally what we do is use message param substitutions with something
// like "{single/plural resource}", which will pick the right resource
// object from context...but that requires report summarization to happen.
// If report summary ISN'T happening for the action, we need a fallback,
// which is what this is.  The gDobj SHOULD never fail (outside of logical
// errors, like trying to use these substitutions in action messages for
// intransitive actions), but the gPlayerChar fallback is there to prevent
// throwing an exception (although the message will be borked and refer to
// the player instad of the actual dobj of the action).
InitObject
	execute() {
		langMessageBuilder.nameTable_['resource'] =
			{: gDobj != nil ? gDobj : gPlayerChar };
	}
;


class ResourceMessageParams: object
	getReportCount() {
		return(reportManager ? reportManager.summarizedReports() : 0);
	}

	singleReport() { return(getReportCount() == 1); }
	singleOrPluralName() { return(singleReport() ? name : pluralName); }
	resourceCount() { return(spellInt(getReportCount())); }

	aOrResourceCount() {
		local n;

		if((n = getReportCount()) == 1)
			return('a');
		else
			return(spellInt(n));
	}

	itThey() { return(singleReport() ? 'it' : 'they'); }

	// Tweak verb endings to use the report count instead of isPlural.
	verbEndingS { return(!singleReport() ? '' : 's'); }
	verbEndingEs { return(tSel(!singleReport() ? '' : 'es', 'ed')); }
	verbEndingIes { return(tSel(!singleReport() ? 'y' : 'ies', 'ied')); }
;
