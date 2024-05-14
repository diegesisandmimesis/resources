#charset "us-ascii"
//
// resourceMessageBuilder.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

modify MessageBuilder
	execBeforeMe = (nilToList(inherited()) + [ resourceMessageBuilder ] )
;

// Random TADS3 lore:  a message parameter substitution tag can be no londer
//	than 13 characters.  If longer, it will silently fail (even if
//	otherwise correctly declared, the substitution won't happen and the
//	tag will be output instead).
resourceMessageBuilder: PreinitObject
	execute() {
		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append([
				'single/plural',
				&singleOrPluralName,
				'resource',
				nil,
				nil
			]);
		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append([
				'count',
				&resourceCount,
				'resource',
				nil,
				nil
			]);
	}
;

modify Thing
	singleOrPluralName() { return(name); }
	resourceCount() { return(toString(spellInt(1))); }
;

InitObject
	execute() {
		langMessageBuilder.nameTable_['resource'] =
			{: gDobj != nil ? gDobj : gPlayerChar };
	}
;
