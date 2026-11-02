namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Models;
    using DocumentConfiguration;

    public static class FspDeliverableExtensions
    {
        public static DeliverableConfiguration ToDeliverableConfiguration(this FSPDeliverable fspDeliverable)
        {
            return new DeliverableConfiguration
            {
                DeliverableCode = fspDeliverable.DeliverableCode,
                IncludeOnFundingAgreement = fspDeliverable.DisplayOnFundingAgreement,
                IsMandatoryOnFundingAgreement = fspDeliverable.MandatoryOnFundingAgreement,
                DisplayOrder = fspDeliverable.DisplayOrderOnFundingAgreement,
                AllowCustomDescription = fspDeliverable.AllowCustomDescription,
                DisplayName = fspDeliverable.DisplayNameOnFundingAgreement,
                DisplayValueIsAggregate = new[] { fspDeliverable.DeliverableCode },
                ShouldDisplayUnitCost = fspDeliverable.ShouldDisplayVolumeAndUnitCost,
                ShouldDisplayVolume = fspDeliverable.ShouldDisplayVolumeAndUnitCost, // these are always the same
                ShouldDisplayValue = fspDeliverable.ShouldDisplayValue
            };
        }

        public static DeliverableConfiguration ToAggregateDeliverableConfiguration(this IEnumerable<FSPDeliverable> fspDeliverablesWhichAllowProfile)
        {
            List<FSPDeliverable> deliverablesWhichAllowProfile = fspDeliverablesWhichAllowProfile.ToList();

            return new DeliverableConfiguration
            {
                DeliverableCode = 0,
                IncludeOnFundingAgreement = true,
                IsMandatoryOnFundingAgreement = true,
                DisplayOrder = deliverablesWhichAllowProfile.Max(fspd => fspd.DisplayOrderOnFundingAgreement) + 1,
                AllowCustomDescription = false,
                DisplayName = "^bTotal Funding¶",
                DisplayValueIsAggregate = deliverablesWhichAllowProfile.Select(fspd => fspd.DeliverableCode).ToArray(),
                ShouldDisplayUnitCost = false,
                ShouldDisplayValue = true,
                ShouldDisplayVolume = false
            };
        }
    }
}