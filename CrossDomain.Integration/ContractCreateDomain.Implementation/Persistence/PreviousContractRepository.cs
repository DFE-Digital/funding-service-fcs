namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using Implementation.Entities;
    using Optional;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;

    public class PreviousContractRepository : IPreviousContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public PreviousContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Option<PreviousContract> GetLastApprovedContract(string contractNumber)
        {
            Option<ContractInfo> contractInfo = GetContractInfos(contractNumber)
                .SingleOrDefault(ci => ci.LastApprovedVersion == true).SomeWhen(c => c != null);

            PreviousContract previousContract = null;
            contractInfo.MatchSome(crmContract =>
            {
                previousContract = new PreviousContract(
                    crmContract.ContractStartDate,
                    crmContract.ContractEndDate,
                    crmContract.MasterContractReferenceNumber,
                    crmContract.AmendmentType,
                    crmContract.ContractDescription,
                    crmContract.ContractType,
                    GetPreviousAllocations(crmContract.CrmId));
            });

            return previousContract.SomeWhen(pc => pc != null);
        }

        public Option<PreviousContract> GetLatestContract(string contractNumber)
        {
            Option<ContractInfo> contractInfo = GetContractInfos(contractNumber)
                .SingleOrDefault(ci => ci.LatestVersion == true).SomeWhen(c => c != null);
            
            PreviousContract previousContract = null;
            contractInfo.MatchSome(crmContract =>
            {
                previousContract = new PreviousContract(
                    crmContract.ContractStartDate,
                    crmContract.ContractEndDate,
                    crmContract.MasterContractReferenceNumber,
                    crmContract.AmendmentType,
                    crmContract.ContractDescription,
                    crmContract.ContractType,
                    GetPreviousAllocations(crmContract.CrmId));
            });

            return previousContract.SomeWhen(pc => pc != null);
        }

        private IReadOnlyCollection<ContractInfo> GetContractInfos(string contractNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return 
                (from master in xrmServiceContext.sfa_contractSet
                    join contract in xrmServiceContext.sfa_contractSet on master.sfa_contractId equals contract.sfa_ParentContractId.Id
                    where contract.sfa_number == contractNumber
                    select new ContractInfo
                    (
                      contract.sfa_StartDate,
                      contract.sfa_EndDate,
                      master.sfa_number,
                      contract.sfa_AmendmentTypeEnum != null ? contract.sfa_AmendmentTypeEnum.ToString() : null,
                      contract.sfa_Description,
                      contract.sfa_ContractType != null ? contract.sfa_ContractType.Name : string.Empty,
                      contract.sfa_contractId,
                      contract.sfa_LastApprovedVersion,
                      contract.sfa_LatestVersion
                    )
                ).ToList();
            }
        }

        private IReadOnlyCollection<PreviousAllocation> GetPreviousAllocations(Guid? contractId)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return 
                (from alloc in xrmServiceContext.sfa_contractallocationSet
                    join fs in xrmServiceContext.sfa_fundingstreamSet on alloc.sfa_FundingStreamId.Id equals
                        fs.sfa_fundingstreamId
                 join fsp in xrmServiceContext.sfa_fundingstreamperiodSet on alloc.sfa_FundingStreamPeriodId.Id equals
                     fsp.sfa_fundingstreamperiodId
                 join contract in xrmServiceContext.sfa_contractSet on alloc.sfa_ContractId.Id equals
                        contract.sfa_contractId
                    where contract.sfa_contractId == contractId
                    select new PreviousAllocation
                    (
                        alloc.sfa_contractallocationnumber,
                        alloc.sfa_startdate,
                        alloc.sfa_enddate,
                        fs.sfa_fundingstreamcode,
                        fsp.sfa_fundingstreamperiodcode,
                        alloc.sfa_LEPName,
                        alloc.sfa_LEPcode,
                        alloc.sfa_ITTReference,
                        alloc.sfa_lotreference,
                        alloc.sfa_awardreference,
                        alloc.sfa_ProjectDescription,
                        alloc.sfa_description,
                        alloc.sfa_AmendmentReason,
                        alloc.sfa_Priority,
                        alloc.sfa_AgreementNumber,
                        alloc.sfa_SpecificationTitle,
                        alloc.sfa_RegionType,
                        alloc.sfa_LearningRatePremium
                    )
                ).ToList();
            }
        }

        private class ContractInfo
        {
            public ContractInfo(DateTime? contractStartDate, DateTime? contractEndDate, string masterContractReferenceNumber,
                string amendmentType, string contractDescription, string contractType, Guid? crmId, bool? lastApprovedVersion, bool? latestVersion)
            {
                ContractStartDate = contractStartDate;
                ContractEndDate = contractEndDate;
                MasterContractReferenceNumber = masterContractReferenceNumber;
                AmendmentType = amendmentType;
                ContractDescription = contractDescription;
                ContractType = contractType;
                CrmId = crmId;
                LastApprovedVersion = lastApprovedVersion;
                LatestVersion = latestVersion;
            }

            public DateTime? ContractStartDate { get; }

            public DateTime? ContractEndDate { get; }

            public string MasterContractReferenceNumber { get; }

            public string AmendmentType { get; }

            public string ContractDescription { get; }

            public string ContractType { get; }

            public Guid? CrmId { get; }

            public bool? LastApprovedVersion { get; }

            public bool? LatestVersion { get; }
        }
    }
}