namespace Datafix.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractInformationRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractInformationRepository()
        {
            CrmConnection connection =
                CrmConnection.Parse(System.Configuration.ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            _organizationService = new OrganizationService(connection);
        }

        public IReadOnlyCollection<ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingTypeCode, string fundingPeriodCode)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                var contracts = (
                    from contract in context.sfa_contractSet
                    join master in context.sfa_contractSet on contract.sfa_ParentContractId.Id equals master.Id
                    join period in context.sfa_periodSet on contract.sfa_PeriodId.Id equals period.Id
                    join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType.Id
                    join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                    where fundingType.sfa_fundingtypecode == fundingTypeCode
                          && period.sfa_periodname == fundingPeriodCode
                          && contract.sfa_HierarchyType.Value == (int) sfa_contracthierarchytype.Contract
                          && contract.sfa_LatestVersion == true
                    select new {Contract = contract, Substatus = sfaStatus.sfa_name, MasterNumber = master.sfa_number}
                    )
                    .ToList();

                return contracts.Select(c => new ContractInformation(
                    c.Contract.sfa_number,
                    c.MasterNumber,
                    c.Contract.sfa_Version.Value,
                    c.Contract.sfa_SubVersion.Value,
                    c.Contract.sfa_UKPRN,
                    CrmToContractInformationStatusTransformer.TransformContractStatus((sfa_contractstatus) c.Contract.sfa_ContractStatus.Value),
                    CrmToContractInformationStatusTransformer.TransformContractSubStatus(c.Substatus))).ToList();
            }
        }
    }
}