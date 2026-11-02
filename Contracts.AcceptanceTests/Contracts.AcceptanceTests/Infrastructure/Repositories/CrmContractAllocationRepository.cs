namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using DTO.ContractTermination;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public static class CrmContractAllocationRepository
    {
        public static Guid? GetLatestApprovedAllocationsGuid(string allocationNumber)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from ca in context.sfa_contractallocationSet
                        join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                        where ca.sfa_contractallocationnumber == allocationNumber
                          && c.sfa_LastApprovedVersion.Value
                        select ca.Id).FirstOrDefault();
            }
        }

        public static AllocationDto GetAllocationByAllocationNumberContractNumberAndContractVersion(string allocationNumber, string contractNumber, int contractVersion)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from ca in context.sfa_contractallocationSet
                        join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                        where ca.sfa_contractallocationnumber == allocationNumber
                            && c.sfa_number == contractNumber
                            && c.sfa_Version == contractVersion
                        select new AllocationDto
                        {
                            AllocationNumber = ca.sfa_contractallocationnumber,
                            ContractNumber = c.sfa_number,
                            VersionNumber = (int)c.sfa_Version,
                            StartDate = ca.sfa_startdate.GetValueOrDefault().ToUniversalTime(),
                            EndDate = ca.sfa_enddate,
                            DeliveryOrgUkprn = ca.sfa_deliveryorganisationukprn,
                            DeliveryOrgProviderUkprn = GetProviderName(ca.sfa_deliveryorganisationprovider == null ? Guid.Empty : ca.sfa_deliveryorganisationprovider.Id),
                            CreatedOn = ca.CreatedOn.Value
                        }).ToList().OrderByDescending(a => a.CreatedOn).FirstOrDefault();
            }
        }

        public static AllocationTerminationValues GetAllocationTerminationValues(string allocationNumber, int versionNumber, int subVersionNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (
                    from a in context.sfa_contractallocationSet
                    join c in context.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                    where a.sfa_contractallocationnumber == allocationNumber
                          && c.sfa_Version == versionNumber
                          && c.sfa_SubVersion == subVersionNumber
                    select new AllocationTerminationValues
                    {
                        AllocationNumber = a.sfa_contractallocationnumber,
                        VersionNumber = c.sfa_Version.Value,
                        SubVersionNumber = c.sfa_SubVersion.Value,
                        StopNewStartsDate = a.sfa_stopnewstartsdate,
                        TerminationDate = a.sfa_terminationdate,
                        FundingCessationDate =  a.sfa_terminationdate,
                        ProvisionalStopNewStartsDate = a.sfa_inflightstopnewstartsdate,
                        ProvisionalFundingCessationDate = a.sfa_inflightterminationdate,
                        NewStartsSuspendedReason = a.sfa_newstartssuspendedreason != null ? Enum.GetName(typeof(sfa_newstartssuspendedreason), a.sfa_newstartssuspendedreason.Value) : null,
                        ProvisionalNewStartsSuspendedReason = a.sfa_inflightnewstartssuspendedreason != null ? Enum.GetName(typeof(sfa_newstartssuspendedreason), a.sfa_inflightnewstartssuspendedreason.Value) : null
                    })
                    .SingleOrDefault();
            }
        }

        public static IReadOnlyCollection<string> GetAllocationNumbersForUkprn(int ukprn)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var allocationNumbersForUkprn = (
                    from a in context.sfa_contractallocationSet
                    join c in context.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                    where c.sfa_UKPRN == ukprn.ToString()
                    select a.sfa_contractallocationnumber).ToList();

                return allocationNumbersForUkprn;
            }
        }

        public static sfa_contractallocation GetLatestContractAllocation(string allocationNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_contractallocation> query =
                    from ca in context.sfa_contractallocationSet
                    join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                    where
                        ca.sfa_contractallocationnumber == allocationNumber &&
                        c.sfa_LatestVersion == true
                    select ca;

                return query.SingleOrDefault();
            }
        }

        private static string GetProviderName(Guid accountId)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.AccountSet.SingleOrDefault(a => a.Id == accountId)?.Name;
            }
        }
    }
}
