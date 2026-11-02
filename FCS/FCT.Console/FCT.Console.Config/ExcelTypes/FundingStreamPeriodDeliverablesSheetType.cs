namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class FundingStreamPeriodDeliverablesSheetType : SheetTypeBase
    {
        public string FundingStreamPeriodCode { get; set; }

        public string FspCode => FundingStreamPeriodCode;

        public int DeliverableCode { get; set; }

        public int? ParentDeliverableCode { get; set; }

        public string DeliverableName { get; set; }

        public string DeliverableRelationshipType { get; set; }

        public bool AllowProfile { get; set; }

        public bool AllowActuals { get; set; }

        public string PaymentSubnominalCodeProfile { get; set; }

        public string PaymentSubnominalCodeReconciliation { get; set; }

        public string PaymentSubnominalCodeCapping { get; set; }

        public bool AllowPayment { get; set; }

        public string DeliverableCappingGroup { get; set; }

        public DateTime CreatedDate { get; set; }

        public bool IsPayable { get; set; }

        public int DisplayOrder { get; set; }

        public string PlanningUnit { get; set; }

        public string  Mandatory { get; set; }

        public string ParentDeliverableName { get; set; }

        // Not on the spreadsheet. Used to help make transforming easier.
        public int? FundingStreamPeriodCappingGroupId { get; set; }

        public bool AllowCustomDeliverableDesc { get; set; }

        public bool AllowClaim { get; set; }

        public string ClaimReconciliationDeliverableGroupCode { get; set; }

        public bool? IsMandatory
        {
            get
            {
                bool isMandatory = false;
                if (!string.IsNullOrEmpty(Mandatory))
                {
                    isMandatory = Mandatory.ToUpper().Equals("MANDATORY");
                }

                return isMandatory;
            }
        }

        public int? CappingApportionmentPriorityOrder { get; set; }

        public bool DisplayOnFundingAgreement { get; set; }

        public bool MandatoryOnFundingAgreement { get; set; }

        public int DisplayOrderOnFundingAgreement { get; set; }

        public bool AllowCustomDescription { get; set; }

        public bool ShouldDisplayValue { get; set; }

        public bool ShouldDisplayVolumeAndUnitCost { get; set; }

        public string DisplayNameOnSummaryOfFunding { get; set; }

        public string DisplayNameOnFundingAgreement { get; set; }

        public bool DisplayOnSummaryOfFunding { get; set; }

        public bool IsAllowedToBeAdded => (IsMandatory?? false) && !AllowProfile && AllowActuals;
    }
}