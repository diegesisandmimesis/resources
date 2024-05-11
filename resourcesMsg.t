#charset "us-ascii"
//
// resourcesMsg.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

modify libMessages
	// Should never happen, but eh.
	resourcesSummaryFailed = '{You/He} notice{s} nothing unusual. '

	//
	resourcesSummarizeExamine(n, obj) {
		return('It\'s <<spellInt(n)>> <<obj.pluralName>>. ');
	}
;
