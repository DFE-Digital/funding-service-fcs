using System.Collections.Generic;
using System.Linq;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

namespace Datafix.Tests.Automation.Releases.R125
{
    public class PublishApprovedBatchOfAppsVariation : IApplyDataFix
    {
        public string Release => "R125";
        public int StoryNumber => 37566;
        public string Name => "Publish Apps Variation Letters";
        public int Order => 1;

        public void ApplyDataFix()
        {
            LevyAmendmentService.AmendMultiple(
                ukprns: new List<string>()
                            {
                                "10037170",
                                "10063340",
                                "10066188",
                                "10065933",
                                "10032256",
                                "10056749",
                                "10089804"
                            },
                amendmentType: AmendmentType.Variation,
                shouldAddPayableNonLevyAllocation: false,
                allowUnderTermination: false,
                shouldMergeAmendmentTemplate: false);
        }
    }
}
