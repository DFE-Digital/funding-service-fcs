using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SFA.FCT.CrossDomain.Integration.Entities;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

namespace Operations.Web.Repositories
{
    public interface IAppLevyRepository
    {
        IReadOnlyCollection<ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingTypeCode, string fundingPeriodCode);
        ContractStatus TransformContractStatus(sfa_contractstatus crmContractstatus);
        ContractSubStatus TransformContractSubStatus(string crmSubstatus);
    }
}
