using System;


namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration
{
    public partial class AllocationAttrsCT
    {
        
        //This is called by .NET Serializer and is needed to prevent generation empty element for nullable property 
        public virtual bool ShouldSerializeProcurementAttrs()
        {
            return ProcurementAttrs != null
               && !String.IsNullOrEmpty(ProcurementAttrs.TenderSpecReference);
        }
    }
}
