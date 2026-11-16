namespace SFA.FCT.ContractRequestDomain.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingTypeFundingPeriod
    {
        private FundingTypeFundingPeriod()
        {
        }

        public FundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriodName)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
        }

        public FundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriodName, DateTime? contractingActivityCloseDate, bool isAllowedToHaveDeliveryOrg) 
            :this(fundingTypeCode, fundingPeriodName)
        {
            ContractingActivityCloseDate = contractingActivityCloseDate;
            AllowUseOfDeliveryOrgs = isAllowedToHaveDeliveryOrg;
        }

        [Key]
        [MaxLength(100)]
        [Column(Order = 1)]
        public string FundingTypeCode { get; private set; }

        [Key]
        [MaxLength(100)]
        [Column(Order = 2)]
        public string FundingPeriodName { get; private set; }

        public DateTime? ContractingActivityCloseDate { get; set; }

        public bool AllowUseOfDeliveryOrgs { get; set; }
    }
}