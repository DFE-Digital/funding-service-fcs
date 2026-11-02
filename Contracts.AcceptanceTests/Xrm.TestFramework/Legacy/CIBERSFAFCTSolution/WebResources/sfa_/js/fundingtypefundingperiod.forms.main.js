function SetName()
{
  //  debugger;
    var FundingTypeName= GetLookupText(Xrm.Page.getAttribute("sfa_fundingtypeid"));
    var FundingPeriodName =  GetLookupText(Xrm.Page.getAttribute("sfa_fundingperiodid"));
      
    var recordname = '';

    if(FundingTypeName !='' && FundingPeriodName !='')
    {
        recordname = FundingTypeName +  " - " + FundingPeriodName ;
    }
    else if (FundingTypeName =='' && FundingPeriodName !='')
    {
        recordname = FundingPeriodName;
    }
    else if (FundingTypeName !='' && FundingPeriodName =='')
    {
        recordname = FundingTypeName;
    }

    Xrm.Page.getAttribute("sfa_name").setValue( recordname);  
   
}


function GetLookupText(lookupObject)
{
    if (lookupObject != null) 
    {
        var lookUpObjectValue = lookupObject.getValue();
        if ((lookUpObjectValue != null)) 
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