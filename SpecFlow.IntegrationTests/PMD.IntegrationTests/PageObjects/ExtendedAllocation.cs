extern alias Entity;
using Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PMD.IntegrationTests.PageObjects
{
    public class ExtendedAllocation
    {
        public Allocation Allocation { get; set; }

        public string AllocationNumber { get { return Allocation.AllocationNumber; } }

        public string FundingStreamPeriodType { get; set; }

        public periodTypeNameType FundingStreamPeriodTypeName { get { return GetPeriodTypeName(FundingStreamPeriodType); } }

        public periodTypeCodeType FundingStreamPeriodTypeCode
        {
            get
            {
                return GetPeriodTypeCode(FundingStreamPeriodType);
            }
        }

        public EsfAllocationData EsfData { get; set; }

        private periodTypeCodeType GetPeriodTypeCode(string fundingStreamPeriodType)
        {
            switch (fundingStreamPeriodType)
            {
                case "AY":
                    return periodTypeCodeType.AY;

                case "FY":
                    return periodTypeCodeType.FY;

                case "EOP":
                    return periodTypeCodeType.EOP;

                default:
                    // would be better to fail fast here, but would doing this break any tests relying on receiving AY as a default?
                    //default:
                    //    throw new Exception("Unknown fundingStreamPeriodType in GetPeriodTypeCode");
                    return periodTypeCodeType.AY;

            }

            // default
        }

        private periodTypeNameType GetPeriodTypeName(string fundingStreamPeriodType)
        {
            switch (fundingStreamPeriodType)
            {
                case "AY":
                    return periodTypeNameType.ACADEMICYEAR;

                case "FY":
                    return periodTypeNameType.FINANCIALYEAR;

                case "EOP":
                    return periodTypeNameType.EMPLOYEROWNERSHIPPILOT;

                default:
                    // would be better to fail fast here, but would doing this break any tests relying on receiving AY as a default?
                    //default:
                    //    throw new Exception("Unknown fundingStreamPeriodType in GetPeriodTypeName");
                    return periodTypeNameType.ACADEMICYEAR;
            }

        }

        public class EsfAllocationData
        {
            public string InvestmentPriority { get; set; }

            public string RegionType { get; set; }
        }
    }
}
