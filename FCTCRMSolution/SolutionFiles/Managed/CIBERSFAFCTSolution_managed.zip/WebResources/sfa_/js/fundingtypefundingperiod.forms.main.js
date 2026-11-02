function SetName(executionContext)
{
	"use strict";
	var formContext = executionContext.getFormContext();
    var FundingTypeName= GetLookupText(formContext.getAttribute("sfa_fundingtypeid"));
    var FundingPeriodName =  GetLookupText(formContext.getAttribute("sfa_fundingperiodid"));
      
    var recordname = '';

    if(FundingTypeName !=='' && FundingPeriodName !=='')
    {
        recordname = FundingTypeName +  " - " + FundingPeriodName ;
    }
    else if (FundingTypeName ==='' && FundingPeriodName !=='')
    {
        recordname = FundingPeriodName;
    }
    else if (FundingTypeName !=='' && FundingPeriodName ==='')
    {
        recordname = FundingTypeName;
    }

    formContext.getAttribute("sfa_name").setValue( recordname);  
   
}


function GetLookupText(lookupObject)
{
	"use strict";
    if (lookupObject !== null) 
    {
        var lookUpObjectValue = lookupObject.getValue();
        if ((lookUpObjectValue !== null)) 
        {	
            return lookUpObjectValue[0].name;
        }
        else
        {
            return '';
        }
    }
    else
    {
        return '';
    }

}