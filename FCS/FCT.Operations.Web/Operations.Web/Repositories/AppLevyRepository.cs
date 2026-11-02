using System.Collections.Generic;
using System.EnterpriseServices;
using System.Linq;
using Operations.Web.Infrastructure;
using SFA.FCT.CrossDomain.Integration.Entities;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
using ContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

namespace Operations.Web.Repositories
{
    public class AppLevyRepository: IAppLevyRepository
    {
        public IReadOnlyCollection<ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingTypeCode, string fundingPeriodCode)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetOrganizationService()))
            {
                var contracts = (
                         from contract in context.sfa_contractSet
                         join master in context.sfa_contractSet on contract.sfa_ParentContractId.Id equals master.Id
                         join period in context.sfa_periodSet on contract.sfa_PeriodId.Id equals period.Id
                         join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType
                             .Id
                         join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                         where fundingType.sfa_fundingtypecode == fundingTypeCode
                               && period.sfa_periodname == fundingPeriodCode
                               && contract.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                               && contract.sfa_LatestVersion == true
                         select new
                         {
                             Contract = contract,
                             Substatus = sfaStatus.sfa_name,
                             MasterNumber = master.sfa_number
                         }
                     )
                     .ToList();

                return contracts.Select(c => new ContractInformation(
                    c.Contract.sfa_number,
                    c.MasterNumber,
                    c.Contract.sfa_Version.Value,
                    c.Contract.sfa_SubVersion.Value,
                    c.Contract.sfa_UKPRN,
                    TransformContractStatus(
                        (sfa_contractstatus)c.Contract.sfa_ContractStatus.Value),
                    TransformContractSubStatus(c.Substatus))).ToList();

            }
        }
        public ContractStatus TransformContractStatus(sfa_contractstatus crmContractstatus)
        {
            Dictionary<sfa_contractstatus, ContractStatus> statuses = new Dictionary<sfa_contractstatus, ContractStatus>
            {
                {sfa_contractstatus.Approved, ContractStatus.Approved},
                {sfa_contractstatus.Closed, ContractStatus.Closed},
                {sfa_contractstatus.Draft, ContractStatus.Draft}
            };

            return statuses.ContainsKey(crmContractstatus) ? statuses[crmContractstatus] : ContractStatus.Other;
        }

        public ContractSubStatus TransformContractSubStatus(string crmSubstatus)
        {
            Dictionary<string, ContractSubStatus> subStatuses = new Dictionary<string, ContractSubStatus>
            {
                {"Approved", ContractSubStatus.Approved},
                {"Awaiting Closure Approval", ContractSubStatus.AwaitingClosureApproval},
                {"Closed", ContractSubStatus.Closed},
                {"Closure in Progress", ContractSubStatus.ClosureinProgress},
                {"Closure Initiation in Progress", ContractSubStatus.ClosureInitiationinProgress},
                {"Published to Provider", ContractSubStatus.PublishedtoProvider},
                {"Awaiting Termination Initiation Approval", ContractSubStatus.AwaitingTerminationInitiationApproval},
                {"Under Termination", ContractSubStatus.UnderTermination},
                {"Modified", ContractSubStatus.Modified}
            };

            return subStatuses.ContainsKey(crmSubstatus) ? subStatuses[crmSubstatus] : ContractSubStatus.Other;
        }


    }
}

   
