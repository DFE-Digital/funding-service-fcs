namespace FundingAllocation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dto;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public static class IntentFundingTypeFundingPeriodExtensions
    {
        public static bool IsNewAmendment(this IntentFundingTypeFundingPeriod intentFundingTypeFundingPeriod, IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos)
        {
            if (intentFundingTypeFundingPeriod.AllowNewAmendment && DetermineIfNewAmendment(crmContractStatusInfos,
                    intentFundingTypeFundingPeriod.PrecedingFtpFundingPeriod, intentFundingTypeFundingPeriod.PrecedingFtpFundingType) &&
                intentFundingTypeFundingPeriod.FtpGroupCode.HasValue())
            {
                return true;
            }

            return false;
        }

        private static bool DetermineIfNewAmendment(IReadOnlyCollection<CrmContractStatusInfo> crmContractStatusInfos,
            string precedingFundingPeriod, string precedingFundingType)
        {
            return crmContractStatusInfos.Any(ccsi => ccsi.LastApprovedVersion &&
                                                      ccsi.IsApproved &&
                                                      ccsi.FundingPeriod == precedingFundingPeriod &&
                                                      ccsi.FundingType == precedingFundingType);
        }
    }
}